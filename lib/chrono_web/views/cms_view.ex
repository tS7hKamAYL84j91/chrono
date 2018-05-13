defmodule ChronoWeb.CMSView do
  use ChronoWeb, :view

  def render("create.json", %{headers: _headers}) do
    %{status: "201 Created"}
  end
end
