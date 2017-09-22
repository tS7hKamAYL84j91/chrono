defmodule Chrono.Update do
  @space Application.get_env(:chrono,:contentful_space)
  @key Application.get_env(:chrono, :contentful_key)

  use GenServer
  require Chrono.Either
  import Ecto.Query


  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    schedule_work() # Schedule work to be performed at some point
    {:ok, state}
  end

  def handle_info(:work, state) do
    schedule_work() # Reschedule once more
    updatewatchdb() 
    |> (&{:noreply, &1}).() # Updated state with results of db update
  end

  def schedule_work() do
    Process.send_after(self(), :work, 24 * 60 * 60 * 1000) # In 2 hours
  end

  defp updatewatchdb() do
    # All these functions have side effects, I prefer to wrap these in a with statement similar to bind/do in Haskell
    # Chrono.Either.either is a macro to wrap functions in {:ok, result} or {:error, msg}
    # Again similar to Result/Either monad.
    # This section is imperative
    with {:ok, pc_updated} <- product_catalogue_last_updated() |> Chrono.Either.either, # Check when catalogue was last updated
      {:ok, watch_tble_updated} <- watch_table_last_updated() |> Chrono.Either.either, # Check when table was last updated 
      {:ok, true} <- watch_tble_updated |> update_required(pc_updated) |> Chrono.Either.either, # determine if we need to update table
      {:ok, {a, _}} when a |> is_integer <- delete_watch_records() |> Chrono.Either.either, # delete existing records
      {:ok,  results} <- insert_watch_records() |> Chrono.Either.either # update the datebase
    do
      {:ok, results |> Enum.reduce([ok: 0,error: 0], &count_results/2)} # function now returns a summary of results
    else
      {:error, %FunctionClauseError{}} -> {:ok, [ok: 0, error: 0]}# in case of %FunctionClauseError{} no updates
      {:error, e} -> {:error, e}
    end
  end

  defp count_results({:ok,_}, [ok: ok, error: error]), do:  [ok: ok + 1, error: error]
  defp count_results(_, [ok: ok, error: error]), do:  [ok: ok, error: error + 1]

  defp insert_watch_records() do
    for w <- Contentful.Delivery.entries(@space, @key, %{"content_type" => "watch"} ) do
      %Chrono.Watch{}
      |> Chrono.Watch.changeset(%{
        name: w["fields"]["name"], 
        description: w["fields"]["description"] , 
        category: 0 })
      |> Chrono.Repo.insert
    end
  end
  
  defp delete_watch_records(), do: (from w in Chrono.Watch) |> Chrono.Repo.delete_all

  defp update_required(watch_tble_updated, pc_updated)
    when watch_tble_updated <= pc_updated or watch_tble_updated == nil, do: true 

  defp watch_table_last_updated() do 
    (from w in Chrono.Watch, select: max(w.updated_at)) 
    |> Chrono.Repo.one
  end

  defp product_catalogue_last_updated() do
    Contentful.Delivery.content_type(@space, @key, "watch") 
    |> get_in(["sys", "updatedAt"])
    |> NaiveDateTime.from_iso8601!
  end

end