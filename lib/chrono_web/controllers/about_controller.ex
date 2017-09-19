defmodule ChronoWeb.AboutController do
	use ChronoWeb, :controller 
	# use Contentful
	# plug Contentful

	def index(conn, _params) do
		render conn, "index.html"
	end
end