defmodule Chrono.ProductCatalogue.Watch do
  use Ecto.Schema
  import Ecto.Changeset
  alias Chrono.ProductCatalogue.Watch


  schema "watches" do

    timestamps()
  end

  @doc false
  def changeset(%Watch{} = watch, attrs) do
    watch
    |> cast(attrs, [])
    |> validate_required([])
  end
end
