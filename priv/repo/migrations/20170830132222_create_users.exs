defmodule Chrono.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :address, :string
    end

  end
end
