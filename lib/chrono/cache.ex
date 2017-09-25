defmodule Chrono.ContentfulCache do\
  @space Application.get_env(:chrono,:contentful_space)
  @key Application.get_env(:chrono, :contentful_key)

  @moduledoc """
  Generic cach for data retrieved from APIs 
  """
  use GenServer
  alias Contentful.Delivery

  # Client API
  @doc """
  Sets up Contentful Cache, populates the subscriptions and the intial cache of data
  """
  def start_link(ress, opts \\ []) do 
    __MODULE__ 
    |> GenServer.start_link(%{subs: ress, data: []}  , name: :contentful_cache)
  end

  @doc """
  Get returns the cached data for the resource passed as an argument  
  """
  def get(res), do: :contentful_cache |> GenServer.call({:get, res})

  @doc """
  Inserts a new resource to be tracked by the cache and refreshes the data
  """
  def insert(res), do: :contentful_cache |> GenServer.cast({:insert, res})

  @doc """
  Refreshes the cache data
  """
  def update_cache, do: :contentful_cache |> GenServer.cast(:update_cache)

  # Server Callbacks
  def init(state), do: {:ok, state |> update_data}
 
  def handle_call({:get, res}, _from, %{data: data} = state) do 
    {:reply, data |> Keyword.get(res |> String.to_atom), state}
  end 

  def handle_cast({:insert, res}, %{subs: ress}=state), do: {:noreply, %{state | subs: [res| ress]} |> update_data }
  def handle_cast(:update_cache, state), do: {:noreply, state |> update_data}

  # Helper functions
  defp update_data(%{subs: subs} = state), do: %{state | data: subs |> Enum.map(&retrieve_res/1)}
  defp retrieve_res(res), do: {res |> String.to_atom, Delivery.entries(@space, @key, %{"content_type" => res})}

end