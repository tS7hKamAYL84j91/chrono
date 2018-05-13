defmodule ChronoWeb.WatchController do
  use ChronoWeb, :controller
  require Logger

  @the_watches "The Watches"

  # plug :put_layout, "basic.html"

  def index(conn, _params),
    do:
      render(
        conn,
        "watches.html",
        watches: Chrono.CMS.get(:watches),
        watches_per_row: 3,
        the_watches: the_watches()
      )

  def show(conn, %{"watch_id" => watch_id}),
    do: render(conn, "watch.html", watch: get_watch_details(watch_id))

  def get_watch_details(watch_id) do
    Chrono.CMS.get(
      :watches,
      fn watches ->
        watches
        |> Enum.find(&(&1.id == watch_id))
      end,
      & &1,
      "",
      __MODULE__
    )
  end

  def the_watches() do
    Chrono.CMS.get(
      :content,
      fn xs -> xs |> Enum.find(&(&1.title == @the_watches)) end,
      & &1,
      nil,
      __MODULE__
    )
  end
end
