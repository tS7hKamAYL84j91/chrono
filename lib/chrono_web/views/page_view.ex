defmodule ChronoWeb.PageView do
  use ChronoWeb, :view
  require Chrono.Either
  require Logger

  def render("cloud.html", assigns),
    do: render("container.html", Map.put(assigns, :style, "bg-cloud"))

  def render("dark.html", assigns),
    do: render("container.html", Map.put(assigns, :style, "bg-dark white-text"))

  def render("page.html", assigns),
    do: render("container.html", Map.put(assigns, :style, "bg-white"))

  def render("shop.html", assigns),
    do: render("container.html", Map.put(assigns, :style, "bg-shop"))

  def render("video.html", assigns),
    do: render("container.html", Map.put(assigns, :style, :video))

  def render("blog.html", assigns),
    do: render("container.html", assigns |> Map.put(:style, :video) |> Map.put(:blog, true))

  def pages(ps), do: ps |> Enum.map(&Map.take(&1, [:title]))

  def recaptcha_key, do: :chrono |> Application.get_env(:recaptcha_key)

  def background_video do
    with %{"fields" => _} = bck_vd <-
           Chrono.CMS.Repo.get(:assets)
           |> Enum.find(&(&1["fields"]["title"] == :chrono |> Application.get_env(:main_video))) do
      bck_vd
    else
      _e ->
        Logger.warn("#{__MODULE__}: Danger Will Robinson no background video defined")
        %{"fields" => %{"file" => %{"url" => "//"}}}
    end
    |> get_in(["fields", "file", "url"])
  end
end
