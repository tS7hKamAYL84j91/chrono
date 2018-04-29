defmodule ChronoWeb.WatchController do
  use ChronoWeb, :controller
  require Logger

  plug :put_layout, "basic.html"

  def index(conn, _params), do: render conn, "watches.html", [watches: Chrono.CMS.get(:watches), watches_per_row: 3]

  def show(conn, %{"watch_id" => watch_id}), do: render conn, "watch.html", watch: get_watch_details(watch_id)
  
  defp get_watch_details(watch_id) do
    Chrono.CMS.get(:watches, 
      fn watches ->   
        watches 
        |> Enum.find(&(&1.id == watch_id))
        |> ChronoWeb.PageView.parse_content end, 
      &(&1),
      "",
      __MODULE__)
  end

end