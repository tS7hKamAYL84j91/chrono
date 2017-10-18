defmodule ChronoWeb.AccountController do
	use ChronoWeb, :controller 
	  plug Ueberauth

  alias Chrono.User
  alias Chrono.Repo

	def index(conn, _params) do
		if conn.assigns[:user] do
			render conn, "index.html"
		else
			conn
	        |> put_flash(:error, "Please sign in")
	        |> redirect(to: "/")
		end
	end
end