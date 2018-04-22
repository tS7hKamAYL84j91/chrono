defmodule Chrono.CMS do
  @moduledoc """
  The CMS context.
  """
  
  alias Chrono.CMS.Repo
  alias Chrono.CMS.Content
  require Chrono.Either
  require Logger

  @pages "chronopage"
  @assets "assets"
  @watches "watch"

  @doc """
  returns content of either pages or assets;  get/5 allows for filters, return fns along with a default value to be set.
  """
  def get(type, filter_fn, return_fn, default_value, caller) do
    with {:ok, rs} <- Chrono.CMS.get(type)
      |> (&filter_fn.(&1)).()
      |> Chrono.Either.either
    do
      return_fn.(rs)
    else
      {:error, err} -> Logger.warn "#{inspect __MODULE__}-#{inspect caller}:#{inspect err} Danger Will Robinson there is no image falling back local"
        default_value
    end
  end

  def get(type) do
    with {:ok, result} when result != nil <- get!(type) |> Chrono.Either.either
    do
      result
    else
      {:ok, nil} -> []
      {:error, e} ->  e
    end 
  end

  def get!(:watches), do: @watches |> Repo.get |> Enum.map(&to_content(:watch, &1))
  def get!(:content), do: @pages |> Repo.get |> Enum.map(&to_content(&1))
  def get!(:assets), do: @assets |> Repo.get

  defp to_content(entry) do
    %Content{id: entry |> get_in(["sys","id"]), 
    title: entry |> get_in(["fields","title"]),
    body: entry |> get_in(["fields","body"]),
    fields: entry |> get_in(["fields"]),
    sys: entry |> get_in(["sys"]), 
    background_img: entry |> get_in(["fields", "bacgroundImage", "fields", "file", "url"]),
    linked_content: entry |> get_in(["fields", "relatedContent"]) |> get_linked_resource}
  end
  
  defp to_content(:watch, entry) do 
    entry 
    |> to_content
    |> Map.put(:body, entry |> get_in(["fields", "description"]))
    |> Map.put(:background_img, entry |> Map.get(:fields) |> get_in(["photo", "fields", "file", "url"]))
  end
    
  defp to_content(_content_type, entry), do: to_content(entry) |> Map.put(:body, entry |> get_in(["fields", "description"]))

  defp get_linked_resource(nil), do: nil
  defp get_linked_resource(xs), do: xs |> Enum.map(&to_content(&1 |> get_in(["sys", "contentType", "sys", "id"]),&1))

end
