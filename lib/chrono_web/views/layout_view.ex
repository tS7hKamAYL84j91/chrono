defmodule ChronoWeb.LayoutView do
  use ChronoWeb, :view
  require Chrono.Either
  require Logger

  def pages(ps), do: ps |> Enum.map(&Map.take(&1, [:title]))

  def recaptcha_key, do: :chrono |> Application.get_env(:recaptcha_key)

end