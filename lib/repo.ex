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
      [{:entries, "chronopage"}], data: []}, name: :contentful_cache)
  end
  @doc """
  Get returns the cached data for the resource passed as an argument  
  """
  def get_all, do: :contentful_cache |> GenServer.call(:get_all)
  def get_all(res) when is_binary(res), do: get_all(res |> String.to_atom)
  def get_all(res) when is_atom(res), do: :contentful_cache |> GenServer.call({:get, res})

  @doc """
  Inserts a new resource to be tracked by the cache and refreshes the data
  """
  def insert(res), do: :contentful_cache |> GenServer.cast({:insert, res})

  @doc """
  Refreshes the cache data
  """
  def update_cache, do: :contentful_cache |> GenServer.cast(:update_cache)

  
  # Server Callbacks
  def init(state) do
    schedule_work()
    {:ok, state |> retrieve_content_types |> update_state}
  end
 
  def handle_call(:get_all, _from, state), do: {:reply, state, state}

  def handle_call({:get, res}, _from, %{data: data} = state) do 
    {:reply, data |> Keyword.get(res), state}
  end 

  def handle_cast({:insert, res}, %{subs: res}=state), do: {:noreply, %{state | subs: [res| res]} |> update_state }
  def handle_cast(:update_cache, state), do: {:noreply, state |> update_state}

  def handle_info(:work, state) do
    schedule_work()
    {:noreply, state |> update_state}
  end
    
  # Helper functions
  defp update_state(%{subs: subs} = state), do: %{state | data: subs |> Task.async_stream(&retrieve_res/1) |> Enum.map(fn {:ok,cont} -> cont end) }
  
  defp retrieve_content_types(state) do
    with ct when ct != nil <- retrieve_content_types
    do
      %{state | subs: [:assets |ct]}
    else
      res -> Logger.warn "{inspect __MODULE__}: Danger Will Robinson Content Type look up failed; {inspect res} "
      state
    end
  end

  defp retrieve_content_types do
    (fn -> retrieve_res(:content_types) end)
    |> Task.async 
    |> Task.await 
    |> Enum.map(&({:entries, &1 |> get_in(["sys","id"])}))
  end

  defp retrieve_res(type) do
    with {:ok, result} when result != nil <- retrieve_res!(type) |> Chrono.Either.either
    do
      result
    else
      {:ok,nil} -> []
      {:error, e} ->  {:error, e}
    end 
  end

  defp retrieve_res!(:content_types), do: Delivery.content_types(space(), key())
  defp retrieve_res!(:assets), do: {:assets, Delivery.assets(space(), key())}
  defp retrieve_res!({:entries, res}), do: {res |> String.to_atom, Delivery.entries(space(), key(), %{"content_type" => res})}

  defp schedule_work(), do: self() |> Process.send_after(:work, schedule())

  defp repo_config,do: Application.get_env(:chrono, Chrono.Repo)
  
  defp schedule, do: repo_config() |> Keyword.get(:schedule, 1000) 
  defp key, do: repo_config() |> Keyword.get(:contentful_key, nil)
  defp space, do: repo_config() |> Keyword.get(:contentful_space, nil) 
  
end