defmodule Chrono.Watch do
  use Ecto.Schema
  import Ecto.Changeset
  alias Chrono.Watch


  schema "watches" do
    field :category, :integer
    field :description, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(%Watch{} = watch, attrs) do
    watch
    |> cast(attrs, [:name, :category, :description])
    |> validate_required([:name, :category, :description])
  end
end
