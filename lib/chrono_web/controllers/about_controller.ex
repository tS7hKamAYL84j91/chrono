defmodule ChronoWeb.AboutController do
	use ChronoWeb, :controller 
	# use Contentful
	# plug Contentful

	def index(conn, _params) do
		conn
		|> render "index.html"
	end
end