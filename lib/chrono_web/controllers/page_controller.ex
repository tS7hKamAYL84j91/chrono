defmodule ChronoWeb.PageController do
  use ChronoWeb, :controller

  def index(conn, _params) do
    render conn, "index.html", 
      all_pages: [] |> all_pages, 
      background_img: background_img()
  end
  
  def all_pages(default), do: Chrono.CMS.get :content, fn content -> content |> Enum.sort_by(&(&1.fields["order"])) end, &(&1), default, __MODULE__

  def background_img do
    Chrono.CMS.get(:assets, 
      fn assets -> assets
        |> Enum.filter(&(&1["fields"]["title"] == "background"))
        |> hd
        |> get_in(["fields","file","url"]) end, 
      fn img -> "https:" <> img end,
      "",
      __MODULE__)
  end

end
