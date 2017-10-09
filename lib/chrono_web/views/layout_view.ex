defmodule ChronoWeb.LayoutView do
  use ChronoWeb, :view

  def pages, do: Chrono.CMS.list_pages |>  Enum.sort_by(&(&1.fields["order"])) |>  Enum.map(&Map.take(&1, [:title])) |> tl

  def background_img do
    "https:" <> 
      (Chrono.CMS.list_assets
      |> Enum.filter(&(&1["fields"]["title"] == "background"))
      |> hd
      |> get_in(["fields","file","url"]))
  end 

end