defmodule Chrono.CMS.Repo do
  @moduledoc """
  Generic cach for data retrieved from APIs 
  """
  use GenServer
  alias Contentful.Delivery
  require Chrono.Either
  require Logger

  @default_medium_url "http://localhost"
  @default_number_of_blogs 3

  # Client API

  @doc """
  Sets up Contentful Cache, populates the subscriptions and the intial cache of data
  """
  def start_link do
    __MODULE__
    |> GenServer.start_link(
      %{subs: [{:entries, "chronopage"}], data: [], last_updated: 0},
      name: :contentful_cache
    )
  end

  @doc """
  Fetches entries from the data store for all content type
  """
  def all, do: :contentful_cache |> GenServer.call(:get_all) |> Map.get(:data)

  @doc """
  Fetches entries for a single content type
  """
  def get(content_type) when is_binary(content_type), do: get(content_type |> String.to_atom())

  def get(content_type) when is_atom(content_type),
    do: :contentful_cache |> GenServer.call({:get, content_type})

  @doc """
  Fetches config for the adaptor.
  """
  def config,
    do: :contentful_cache |> GenServer.call(:get_all) |> Map.take([:last_updated, :subs])

  @doc """
  Invalidates the cache of content held in the repo.
  """
  def invalidate_cache, do: :contentful_cache |> GenServer.cast(:invalidate_cache)

  # Server Callbacks

  @doc """
  A callback executed when the repo starts or when configuration is read
  """
  def init(state), do: {:ok, state |> retrieve_content_types |> update_cache}

  def handle_call(:get_all, _from, state), do: state |> update_cache |> (&{:reply, &1, &1}).()

  def handle_call({:get, content_type}, _from, state),
    do:
      state
      |> update_cache
      |> (&{:reply, &1 |> Map.get(:data) |> Keyword.get(content_type), &1}).()

  def handle_cast(:invalidate_cache, state), do: {:noreply, %{state | last_updated: 0}}

  # Helper functions

  defp update_cache(%{last_updated: last_updated, subs: subs} = state) do
    case cache_stale(last_updated) do
      true ->
        %{
          state
          | data:
              subs |> Task.async_stream(&retrieve_data/1) |> Enum.map(fn {:ok, cont} -> cont end),
            last_updated: now()
        }

      false ->
        state
    end
  end

  defp cache_stale(last_updated), do: now() - last_updated > schedule()
  defp now(), do: :calendar.datetime_to_gregorian_seconds(:calendar.local_time())

  defp retrieve_content_types(state),
    do:
      retrieve_data(:content_types)
      |> Enum.map(&{:entries, &1 |> get_in(["sys", "id"])})
      |> (&%{state | subs: [:blog_posts, :assets | &1]}).()

  defp retrieve_data(type, default \\ []) do
    with {:ok, result} when result != nil <- type |> retrieve_data! |> Chrono.Either.either() do
      result
    else
      e ->
        Logger.warn(
          "#{inspect(__MODULE__)}: Danger Will Robinson Content Type retrieval failed; #{
            inspect(e)
          } "
        )

        default
    end
  end

  defp retrieve_data!(:content_types), do: Delivery.content_types(space(), key())
  defp retrieve_data!(:assets), do: {:assets, Delivery.assets(space(), key())}

  defp retrieve_data!(:blog_posts) do
    Logger.debug("GET; #{medium_url()}")

    with {:ok, resp} <- HTTPoison.get(medium_url()),
         {:ok, rss} when rss != nil <- resp |> Map.get(:body) |> Chrono.Either.either(),
         {:ok, %Fiet.Feed{items: items}} <- Fiet.parse(rss) do
      {:blog_posts, items |> Enum.take(number_of_blogs())}
    else
      e ->
        Logger.warn(
          "#{inspect(__MODULE__)}: Danger Will Robinson blog retrieval failed; #{inspect(e)} "
        )
    end
  end

  defp retrieve_data!({:entries, content_type}),
    do:
      {content_type |> String.to_atom(),
       Delivery.entries(space(), key(), %{"content_type" => content_type})}

  defp repo_config, do: Application.get_env(:chrono, Chrono.CMS.Repo)

  defp schedule, do: repo_config() |> Keyword.get(:schedule, nil)
  defp key, do: repo_config() |> Keyword.get(:contentful_key, nil)
  defp space, do: repo_config() |> Keyword.get(:contentful_space, nil)

  defp medium_url, do: repo_config() |> Keyword.get(:medium_url, @default_medium_url)

  defp number_of_blogs, do: repo_config() |> Keyword.get(:default_posts, @default_number_of_blogs)
end
