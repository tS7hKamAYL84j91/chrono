defmodule ChronoWeb.LayoutView do
  use ChronoWeb, :view
  require Chrono.Either
  require Logger

  def pages do
    Chrono.CMS.get_all(:content, 
      fn content -> content 
        |> Enum.sort_by(&(&1.fields["order"])) 
        |> Enum.map(&Map.take(&1, [:title]))
        |> tl end, 
      &(&1),
      [],
      "pages")
  end

  def background_img do
    Chrono.CMS.get_all(:assets, 
      fn assets -> assets
        |> Enum.filter(&(&1["fields"]["title"] == "background"))
        |> hd
        |> get_in(["fields","file","url"]) end, 
      fn img -> "https:" <> img end,
      "",
      "background_img")
  end

end