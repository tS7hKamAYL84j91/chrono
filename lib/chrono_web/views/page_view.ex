defmodule ChronoWeb.PageView do
  use ChronoWeb, :view
  require Chrono.Either
  require Logger

  def welcome, do: all_pages(&hd/1 ,%{html: "<h1>Its all gone Pete Tong</h1>"}, "welcome")
  def pages, do: all_pages(&tl/1 ,[], "pages")
   
  def all_pages(tf, default, name) do
    Chrono.CMS.get_all(:content, 
      fn content -> content 
        |> Enum.sort_by(&(&1.fields["order"])) 
        |> Enum.map(&parse_content/1)
        |> (&tf.(&1)).()
      end, 
      &(&1),
      default,
      name)
  end

  defp parse_content(cont), do: cont |> Map.put(:html, cont.body |> parse_html) |> Map.take([:id, :title, :html, :background_img])

  defp parse_html(body) do
    with {:ok, html, _} <- body |> Earmark.as_html do 
      html 
    else 
      _e -> "<p>Danger Will Robinson ... error |> no content</p>"
    end 
  end

end