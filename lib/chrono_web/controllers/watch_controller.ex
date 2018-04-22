defmodule ChronoWeb.WatchController do
  use ChronoWeb, :controller
  require Logger

  def index(conn, _params) do
    render conn, "watches.html", [watches: Chrono.CMS.get(:watches), watches_per_row: 4]
  end
  
end