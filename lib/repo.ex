defmodule Chrono.Repo do
  @moduledoc """
  Generic cach for data retrieved from APIs 
  """
  use GenServer
  alias Contentful.Delivery
  require Chrono.Either
  require Logger

  # Client API
  @doc """
  Sets up Contentful Cache, populates the subscriptions and the intial cache of data
  """
  def start_link do 
    __MODULE__ 
    |> GenServer.start_link(%{subs: 
      [{:entries, "chronopage"}], data: [], last_updated: 0}, name: :contentful_cache)
  end
  @doc """
  Get returns the cached data for the resource passed as an argument  
  """
  def get_all, do: :contentful_cache |> GenServer.call(:get_all)
  def get_all(res) when is_binary(res), do: get_all(res |> String.to_atom)
  def get_all(res) when is_atom(res), do: :contentful_cache |> GenServer.call({:get, res})

  @doc """
  Refreshes the cache data
  """
  def invalidate_cache, do: :contentful_cache |> GenServer.cast(:invalidate_cache)

  # Server Callbacks
  def init(state), do: {:ok, state |> retrieve_content_types |> update_cache}
 
  def handle_call(:get_all, _from, state), do: state |> update_cache |> (&{:reply, &1, &1}).()
  def handle_call({:get, res}, _from, state),do: state |> update_cache |> (&{:reply, &1 |> Map.get(:data) |> Keyword.get(res), &1}).()

  def handle_cast(:invalidate_cache, state), do: {:noreply, %{state | last_updated: 0}}

  # Helper functions
  def update_cache(%{last_updated: last_updated, subs: subs}=state) do
    case cache_stale(last_updated) do
      true -> %{state | data: subs |> Task.async_stream(&retrieve_data/1) |> Enum.map(fn {:ok,cont} -> cont end), last_updated: now()}
      false -> state
    end
  end

  defp now(), do: :calendar.datetime_to_gregorian_seconds(:calendar.local_time)
  defp cache_stale(last_updated), do: now() - last_updated > schedule()

  defp retrieve_content_types(state) do
    with ct when ct != nil <- :content_types |> retrieve_data! |> Enum.map(&({:entries, &1 |> get_in(["sys","id"])}))
    do
      %{state | subs: [:assets |ct]}
    else
      e ->
        Logger.warn "#{inspect __MODULE__}: Danger Will Robinson Content Type look up failed; #{inspect e} "
        state
    end
  end

  defp retrieve_data(type) do
    with {:ok, result} when result != nil <- retrieve_data!(type) |> Chrono.Either.either
    do
      result
    else
      {:ok,nil} -> []
      {:error, e} ->  
        Logger.warn "#{inspect __MODULE__}: Danger Will Robinson Content Type retrieval failed; #{inspect e} "
        {:error, e}
    end 
  end

  defp retrieve_data!(:content_types), do: Delivery.content_types(space(), key())
  defp retrieve_data!(:assets), do: {:assets, Delivery.assets(space(), key())}
  defp retrieve_data!({:entries, res}), do: {res |> String.to_atom, Delivery.entries(space(), key(), %{"content_type" => res})}

  defp repo_config, do: Application.get_env(:chrono, Chrono.Repo)

  defp schedule, do: repo_config() |> Keyword.get(:schedule, nil) 
  defp key, do: repo_config() |> Keyword.get(:contentful_key, nil)
  defp space, do: repo_config() |> Keyword.get(:contentful_space, nil)
   
  
end