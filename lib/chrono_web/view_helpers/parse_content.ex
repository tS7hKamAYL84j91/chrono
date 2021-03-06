defmodule ChronoWeb.ViewHelper.ParseContent do
  require Chrono.Either
  require Logger

  def parse_content_pages(ps), do: ps |> Enum.map(&parse_content/1)

  def parse_content(cont) do
    cont
    |> Map.put(:html, cont.body |> parse_html)
    |> Map.put(:template, cont |> apply_template)
    |> Map.put(:background_img, cont |> format_photo)
    |> Map.put(:linked_content, cont |> linked_content)
    |> Map.take([:id, :title, :html, :background_img, :template, :linked_content])
  end

  def parse_html(body) do
    with {:ok, {:ok, html, _}} <- body |> Earmark.as_html() |> Chrono.Either.either() do
      html
    else
      _e ->
        Logger.warn("#{__MODULE__}: Danger Will Robinson no html defined #{body}")
        "<p>Danger Will Robinson ... error |> no content</p>"
    end
  end

  defp apply_template(%{:sys => %{"contentType" => %{"sys" => %{"id" => "watch"}}}}),
    do: "showcase_img"

  defp apply_template(cont),
    do: cont |> Map.from_struct() |> get_in([:fields, "template"]) |> default_template(cont)

  defp default_template(nil, cont) do
    Logger.warn("#{__MODULE__}: Danger Will Robinson no templated defined #{cont.title}")
    "page"
  end

  defp default_template(t, _), do: t

  defp format_photo(%{:sys => %{"contentType" => %{"sys" => %{"id" => "watch"}}}} = cont),
    do: cont |> Map.from_struct() |> get_in([:fields, "photo", "fields", "file", "url"])

  defp format_photo(cont), do: cont.background_img

  defp linked_content(%Chrono.CMS.Content{linked_content: nil}), do: nil
  defp linked_content(%Chrono.CMS.Content{linked_content: cs}), do: cs |> parse_content_pages
end
