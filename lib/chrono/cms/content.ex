defmodule Chrono.CMS.Content do
  @content [:id, :title, :fields, :sys, :body, :background_img, :linked_content]
  
  defstruct  @content

  def content, do: @content
end