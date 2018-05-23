defmodule ChronoWeb.WatchView do
  use ChronoWeb, :view

  @default_content %{:title => "The Watches", :html => "This is our collection"}

  def parse_result(nil), do: @default_content
  def parse_result(content), do: content |> ChronoWeb.ViewHelper.ParseContent.parse_content()

  def parse_watch(watch) do
    watch
    |> ChronoWeb.ViewHelper.ParseContent.parse_content()
    |> Map.put(:full_description, watch |> watch_description)
    |> Map.put(:details, watch |> watch_details)
    |> Map.put(:supporting_photos, watch |> supporting_photos("supporting_photo"))
    |> Map.put(:main_img, watch |> supporting_photos("photo"))
  end

  def watch_description(watch) do
    watch
    |> Map.from_struct()
    |> get_in([:fields, "full_description"])
    |> ChronoWeb.ViewHelper.ParseContent.parse_html()
  end

  def watch_details(watch) do
    watch
    |> Map.from_struct()
    |> Map.get(:fields)
    |> Enum.filter(fn {k, _v} -> String.contains?(k, ["details"]) end)
    |> Enum.map(fn {k, v} -> {k |> normalise_watch_detail_labels, v} end)
    |> Enum.filter(fn {_k, v} -> v != nil end)
    |> Enum.map(fn {k, v} -> %{label: k, value: v} end)
  end

  def normalise_watch_detail_labels(label) do
    label
    |> String.replace("details", "")
    |> String.replace("_", " ")
    |> String.trim()
    |> String.split()
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(" ")
  end

  def supporting_photos(watch, img_name),
    do: watch |> Map.from_struct() |> Map.get(:fields) |> photo_details(img_name)

  def photo_details(photo, "supporting_photo" = img_name),
    do: photo |> Map.get(img_name, []) |> Enum.map(&photo_details/1)

  def photo_details(photo, "photo" = img_name), do: photo |> Map.get(img_name) |> photo_details

  def photo_details(photo) do
    %{
      :photo => photo |> get_in(["fields", "file", "url"]),
      :title => photo |> get_in(["fields", "file", "title"])
    }
  end
end
