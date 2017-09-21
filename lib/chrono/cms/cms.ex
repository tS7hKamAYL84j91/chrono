defmodule Chrono.CMS do
  @moduledoc """
  The CMS context.
  """
  
  alias Contentful.Delivery
  alias Chrono.CMS.Content

  @space Application.get_env(:chrono,:contentful_space)
  @key  Application.get_env(:chrono,:contentful_key)
  @about_content_type "chronopage"

  @doc """
  List content returns all content it defaults to front page content 
  """
  def list_content(content_type \\ @about_content_type) do
     @space 
     |> Delivery.entries(@key, %{"content_type" => content_type})
     |> Enum.map(&summarise_content/1)
  end

  @doc """
  Gets a single content entry based on id
  """
  def get_content!(id), do: @space |> Delivery.entry(@key, id) |> summarise_content
  
  defp summarise_content(entry) do 
    %Content{id: entry["sys"]["id"], 
    title: entry["fields"]["title"],
    fields: entry["fields"]}
  end

end
