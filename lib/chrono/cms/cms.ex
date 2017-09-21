defmodule Chrono.CMS do
  @moduledoc """
  The CMS context.
  """
  
  alias Contentful.Delivery

  @space Application.get_env(:chrono,:contentful_space)
  @key  Application.get_env(:chrono,:contentful_key)
  @chrono_content_type "chronopage"

  @doc """
  List content returns all Chrono front page content along with ids
  """
  def list_content do
     @space 
     |> Delivery.entries(@key, %{"content_type" => @chrono_content_type})
     |> Enum.map(&summarise_content/1)

  end

  @doc """
  Gets a single content.
  """
  def get_content!(id), do: @space |> Delivery.entry(@key, id) |> summarise_content

  
  defp summarise_content(entry) do 
    %{id: entry["sys"]["id"], 
    title: entry["fields"]["title"],
    body: entry["fields"]["body"]}
  end

end
