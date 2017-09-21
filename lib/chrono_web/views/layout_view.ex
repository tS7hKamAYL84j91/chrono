defmodule ChronoWeb.LayoutView do
  use ChronoWeb, :view

  def pages, do: Chrono.CMS.list_content
end
