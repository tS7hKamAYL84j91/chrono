defmodule Chrono.CMS do
  @moduledoc """
  The CMS context.
  """
  
  alias Chrono.Contentful.Repo
  alias Chrono.CMS.Content

  @content_type "chronopage"

  @doc """
  List content returns all content it defaults to front page content 
  """
  def list_content do
    @content_type
    |> Repo.get
    |> Enum.map(&summarise_content/1)
  end

  @doc """
  Gets a single content entry based on id
  """
  def get_content!(id), do: list_content |> Enum.find(&(&1.id == id))
  
  defp summarise_content(entry) do 
    %Content{id: entry["sys"]["id"], 
    title: entry["fields"]["title"],
    fields: entry["fields"],
    sys: entry["sys"]}
  end

end
