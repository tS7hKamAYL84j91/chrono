defmodule Chrono.Repo.Migrations.CreateWatches do
  use Ecto.Migration

  def change do
    create table(:watches) do
      add :name, :string
      add :category, :integer
      add :description, :string

      timestamps()
    end

  end
end
