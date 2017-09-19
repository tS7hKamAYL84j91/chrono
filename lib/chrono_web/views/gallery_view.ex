defmodule ChronoWeb.GalleryView do
  use ChronoWeb, :view

  def getwatches do
	allwatches = Contentful.Delivery.entries(System.get_env("SPACE_ID"), System.get_env("ACCESS_TOKEN"), %{"content_type" => "watch"} )
  end
end
