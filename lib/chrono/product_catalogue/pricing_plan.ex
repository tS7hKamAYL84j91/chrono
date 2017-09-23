defmodule Chrono.ProductCatalogue.PricingPlan do
  use Ecto.Schema
  import Ecto.Changeset
  alias Chrono.ProductCatalogue.PricingPlan


  schema "pricingplans" do

    timestamps()
  end

  @doc false
  def changeset(%PricingPlan{} = pricing_plan, attrs) do
    pricing_plan
    |> cast(attrs, [])
    |> validate_required([])
  end
end
