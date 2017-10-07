defmodule Chrono.ProductCatalogue do
  alias Chrono.Contentful.Repo

  @moduledoc """
  The ProductCatalogue context.
  """
  def get_plans, do: Repo.get("pricingPlans") |> Enum.map(&summarise_plan/1)

  def summarise_plan(res) do
      %Chrono.ProductCatalogue.PricingPlan{
        id: res |> get_in(["sys","id"]), 
        title: res |> get_in(["fields","title"]), 
        description: res |> get_in(["fields","description"]),
        ppm: res |> get_in(["fields","pricePerMonth"])
      }
  end

end
