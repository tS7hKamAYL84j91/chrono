defmodule ChronoWeb.PageView do
  use ChronoWeb, :view
  require Chrono.Either
  require Logger

  def parse_pages(ps), do: ps |> Enum.map(&parse_content/1)

  defp parse_content(cont) do 
    cont 
    |> Map.put(:html, cont.body |> parse_html) 
    |> Map.put(:template, cont |> get_template )
    |> Map.take([:id, :title, :html, :background_img, :template])
  end

  defp parse_html(body) do
    with {:ok, html, _} <- body |> Earmark.as_html do 
      html 
    else 
      _e -> "<p>Danger Will Robinson ... error |> no content</p>"
    end 
  end

  defp get_template(page), do: page |> Map.from_struct |> get_in([:fields, "template"]) |> default_template(page) 
  
  defp default_template(nil, page) do 
    Logger.warn "#{__MODULE__}: Danger Will Robinson no templated defined #{page.title}"
    "page"
  end
  defp default_template(t, _), do: t


end