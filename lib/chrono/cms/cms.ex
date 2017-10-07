defmodule Chrono.CMS do
  @moduledoc """
  The CMS context.
  """
  
  alias Chrono.Contentful.Repo
  alias Chrono.CMS.Content
  Earm

  @pages "chronopage"
  @welcome "welcome"
  @assets "assets"

  @doc """
  List content returns all content it defaults to front page content 
  """
  def list_pages do
    @pages
    |> Repo.get
    |> Enum.map(&summarise_content/1)
  end

  @doc """
  List media in CMS
  """
  def list_assets do
    @assets
    |> Repo.get
  end

  @doc """
  Gets the main welcome message
  """
  def get_welcome do
    @welcome
    |> Repo.get |> Enum.map(&summarise_content/1)
  end


  @doc """
  Gets a single content entry based on id
  """
  def get_content!(id), do: list_pages() |> Enum.find(&(&1.id == id))
  
  defp summarise_content(entry) do 
    %Content{id: entry["sys"]["id"], 
    title: entry["fields"]["title"],
    fields: entry["fields"],
    sys: entry["sys"], 
    body: entry["fields"]["body"],
    background_img: entry["fields"]["bacgroundImage"]["fields"]["file"]["url"]}
  end


  

end
