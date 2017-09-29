defmodule ChronoWeb.LayoutView do
  use ChronoWeb, :view

  def pages, do: Chrono.CMS.list_content |>  Enum.sort_by(&(&1.fields["order"])) |>  Enum.map(&Map.take(&1, [:title, ]))

  def background_img do
    "https:" <> 
      (Chrono.CMS.get_assets 
      |> Enum.filter(&(&1["fields"]["title"] == "background"))
      |> hd
      |> get_in(["fields","file","url"]))
  end 

end