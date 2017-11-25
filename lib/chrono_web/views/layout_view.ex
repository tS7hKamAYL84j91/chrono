defmodule ChronoWeb.LayoutView do
  use ChronoWeb, :view
  require Chrono.Either
  require Logger

  def pages(ps), do: ps |> Enum.map(&Map.take(&1, [:title])) |> tl

end