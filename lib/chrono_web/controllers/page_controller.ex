defmodule ChronoWeb.PageController do
  use ChronoWeb, :controller

  def index(conn, _params), do: render(conn, "index.html")

end
