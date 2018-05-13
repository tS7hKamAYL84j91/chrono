defmodule ChronoWeb.CMSController do
  use ChronoWeb, :controller
  require Logger

  def create(conn, _params) do
    Logger.debug(inspect(conn))
    Chrono.CMS.Repo.invalidate_cache()

    conn
    |> Plug.Conn.put_status(:created)
    |> render("create.json", headers: conn.req_headers)
  end
end
