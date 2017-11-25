defmodule ChronoWeb.PageView do
  use ChronoWeb, :view
  require Chrono.Either
  require Logger

  def pages(ps), do: ps |> Enum.map(&parse_content/1)

  defp parse_content(cont), do: cont |> Map.put(:html, cont.body |> parse_html) |> Map.take([:id, :title, :html, :background_img])

  defp parse_html(body) do
    with {:ok, html, _} <- body |> Earmark.as_html do 
      html 
    else 
      _e -> "<p>Danger Will Robinson ... error |> no content</p>"
    end 
  end

end