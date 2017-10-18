defmodule Chrono.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Chrono.User


  schema "users" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :address, :string
    field :provider, :string
    field :token, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :email, :address, :provider, :token])
    |> validate_required([:first_name, :last_name, :email, :address, :provider, :token])
  end
end
