defmodule Chrono.Contentful.Repo do\
  @repo_config Application.get_env(:chrono, Chrono.Contentful.Repo)
  
  @schedule @repo_config |> Keyword.get(:schedule, 1000) 
  @key @repo_config |> Keyword.get(:contentful_key, nil)
  @space @repo_config |> Keyword.get(:contentful_space, nil)
  
  @moduledoc """
  Generic cach for data retrieved from APIs 
  """
  use GenServer
  alias Contentful.Delivery

  # Client API
  @doc """
  Sets up Contentful Cache, populates the subscriptions and the intial cache of data
  """
  def start_link do
    __MODULE__ 
    |> GenServer.start_link(%{subs: [:assets | retrieve_content_types()] , data: []}  , name: :contentful_cache)
  end

  @doc """
  Get returns the cached data for the resource passed as an argument  
  """
  def get(res), do: :contentful_cache |> GenServer.call({:get, res})
  def get_all, do: :contentful_cache |> GenServer.call(:get_all)

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
    {:ok, state |> update_data}
  end

  def handle_call(:get_all, _from, state), do: {:reply, state, state}

  def handle_call({:get, res}, _from, %{data: data} = state) do 
    {:reply, data |> Keyword.get(res |> String.to_atom), state}
  end 

  def handle_cast({:insert, res}, %{subs: res}=state), do: {:noreply, %{state | subs: [res| res]} |> update_data }
  def handle_cast(:update_cache, state), do: {:noreply, state |> update_data}

  def handle_info(:work, state) do
    schedule_work()
    {:noreply, state |> update_data}
  end
  # Helper functions
  defp update_data(%{subs: subs} = state), do: %{state | data: subs |> Task.async_stream(&retrieve_res/1) |> Enum.map(fn {:ok,cont} -> cont end) }
  
  def retrieve_content_types do
    (fn -> Delivery.content_types(@space, @key) end)
    |> Task.async 
    |> Task.await 
    |> Enum.map(&({:entries, &1 |> get_in(["sys","id"])}))
  end

  defp retrieve_res({:entries, res}), do: {res |> String.to_atom, Delivery.entries(@space, @key, %{"content_type" => res})}
  defp retrieve_res(:assets), do: {:assets, Delivery.assets(@space, @key)}
  
  defp schedule_work(), do: self() |> Process.send_after(:work, @schedule)


end