defmodule Chrono.Repo.Migrations.CreateWatches do
  use Ecto.Migration

  def change do
    create table(:watches) do

      timestamps()
    end

  end
end
