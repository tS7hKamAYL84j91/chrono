defmodule ChronoWeb.PageView do
  use ChronoWeb, :view

  def pages, do: Chrono.CMS.list_content |>  Enum.sort_by(&(&1.fields["order"])) |> Enum.map(&parse_content/1)

  defp parse_content(cont), do: cont |> Map.put(:html, cont.body |> parse_html) |> Map.take([:title,:html])

  defp parse_html(body) do
    with {:ok, html, _} <- body |> Earmark.as_html do 
      html 
    else 
      _e -> "<p>Danger Will Robinson ... error |> no content</p>"
    end 
  end

end
