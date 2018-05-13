defmodule ChronoWeb.WatchView do
  use ChronoWeb, :view

  @default_content %{:title => "The Watches", :html => "This is our collection"}
  @the_watches "The Watches"

  def the_watches() do
    Chrono.CMS.get(
      :content,
      fn xs -> xs |> Enum.find(&(&1.title == @the_watches)) end,
      & &1,
      @default_content,
      __MODULE__
    )
    |> parse_result
  end

  def parse_result(nil), do: @default_content
  def parse_result(content), do: content |> ChronoWeb.PageView.parse_content()

  def parse_watch(watch) do
    watch
    |> ChronoWeb.PageView.parse_content()
    |> Map.put(:full_description, watch |> watch_description)
    |> Map.put(:details, watch |> watch_details)
    |> Map.put(:supporting_photos, watch |> supporting_photos)
    |> rename_key(:background_img, :main_img)
  end

  def watch_description(watch) do
    watch
    |> Map.from_struct()
    |> get_in([:fields, "full_description"])
    |> ChronoWeb.PageView.parse_html()
  end

  def watch_details(watch) do
    watch
    |> Map.from_struct()
    |> Map.get(:fields)
    |> Enum.filter(fn {k, _v} -> String.contains?(k, ["details"]) end)
    |> Enum.map(fn {k, v} -> {k |> normalise_labels, v} end)
    |> Enum.filter(fn {_k, v} -> v != nil end)
    |> Enum.map(fn {k, v} -> %{label: k, value: v} end)
  end

  def normalise_labels(label) do
    label
    |> String.replace("details", "")
    |> String.replace("_", " ")
    |> String.trim()
    |> String.split()
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(" ")
  end

  def supporting_photos(watch) do
    watch
    |> Map.from_struct()
    |> Map.get(:fields)
    |> Map.get("supporting_photo", [])
    |> Enum.map(&photo_details/1)
  end

  def photo_details(photo) do
    %{
      :photo => photo |> get_in(["fields", "file", "url"]),
      :title => photo |> get_in(["fields", "file", "title"])
    }
  end

  def rename_key(map, old_key, new_key) do
    map |> Map.pop(old_key) |> (fn {v, m} -> Map.put(m, new_key, v) end).()
  end
end
