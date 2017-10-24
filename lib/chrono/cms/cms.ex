defmodule Chrono.CMS do
  @moduledoc """
  The CMS context.
  """
  
  alias Chrono.Contentful.Repo
  alias Chrono.CMS.Content
  require Chrono.Either

  @pages "chronopage"
  @assets "assets"

  @doc """
  get_all returns content of either pages or assets
  """

  def get_all(type) do
    with {:ok, result} when result != nil <- get_all!(type) |> Chrono.Either.either
    do
      result
    else
      {:ok,nil} -> []
      {:error, e} ->  {:error, e}
    end 
  end


  def get_all!(:content), do: @pages |> Repo.get_all |> Enum.map(&to_content(&1))
  def get_all!(:assets), do: @assets |> Repo.get_all

  defp to_content(entry) do
    %Content{id: entry |> get_in(["sys","id"]), 
    title: entry |> get_in(["fields","title"]),
    body: entry |> get_in(["fields","body"]),
    fields: entry |> get_in(["fields"]),
    sys: entry |> get_in(["sys"]), 
    background_img: entry |> get_in(["fields", "bacgroundImage", "fields", "file", "url"]),
    linked_content: entry |> get_in(["fields", "relatedContent"]) |> get_linked_resource}
  end
  
  defp to_content(_content_type, entry), do: to_content(entry) |> Map.put(:body, entry |> get_in(["fields", "description"]))

  defp get_linked_resource(nil), do: nil
  defp get_linked_resource(xs), do: xs |> Enum.map(&to_content(&1 |> get_in(["sys", "contentType", "sys", "id"]),&1))

end
