defmodule ChronoWeb.GalleryView do
  use ChronoWeb, :view

  def getwatches do
	allwatches = Contentful.Delivery.entries(Application.get_env(:chrono,:contentful_space), Application.get_env(:chrono,:contentful_key), %{"content_type" => "watch"} )
  end
end
