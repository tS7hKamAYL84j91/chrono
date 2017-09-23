defmodule Chrono.Repo.Migrations.CreatePricingplans do
  use Ecto.Migration

  def change do
    create table(:pricingplans) do

      timestamps()
    end

  end
end
