defmodule Chrono.ProductCatalogueTest do
  use Chrono.DataCase

  alias Chrono.ProductCatalogue

  describe "pricingplans" do
    alias Chrono.ProductCatalogue.PricingPlan

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def pricing_plan_fixture(attrs \\ %{}) do
      {:ok, pricing_plan} =
        attrs
        |> Enum.into(@valid_attrs)
        |> ProductCatalogue.create_pricing_plan()

      pricing_plan
    end

    test "list_pricingplans/0 returns all pricingplans" do
      pricing_plan = pricing_plan_fixture()
      assert ProductCatalogue.list_pricingplans() == [pricing_plan]
    end

    test "get_pricing_plan!/1 returns the pricing_plan with given id" do
      pricing_plan = pricing_plan_fixture()
      assert ProductCatalogue.get_pricing_plan!(pricing_plan.id) == pricing_plan
    end

    test "create_pricing_plan/1 with valid data creates a pricing_plan" do
      assert {:ok, %PricingPlan{} = pricing_plan} = ProductCatalogue.create_pricing_plan(@valid_attrs)
    end

    test "create_pricing_plan/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ProductCatalogue.create_pricing_plan(@invalid_attrs)
    end

    test "update_pricing_plan/2 with valid data updates the pricing_plan" do
      pricing_plan = pricing_plan_fixture()
      assert {:ok, pricing_plan} = ProductCatalogue.update_pricing_plan(pricing_plan, @update_attrs)
      assert %PricingPlan{} = pricing_plan
    end

    test "update_pricing_plan/2 with invalid data returns error changeset" do
      pricing_plan = pricing_plan_fixture()
      assert {:error, %Ecto.Changeset{}} = ProductCatalogue.update_pricing_plan(pricing_plan, @invalid_attrs)
      assert pricing_plan == ProductCatalogue.get_pricing_plan!(pricing_plan.id)
    end

    test "delete_pricing_plan/1 deletes the pricing_plan" do
      pricing_plan = pricing_plan_fixture()
      assert {:ok, %PricingPlan{}} = ProductCatalogue.delete_pricing_plan(pricing_plan)
      assert_raise Ecto.NoResultsError, fn -> ProductCatalogue.get_pricing_plan!(pricing_plan.id) end
    end

    test "change_pricing_plan/1 returns a pricing_plan changeset" do
      pricing_plan = pricing_plan_fixture()
      assert %Ecto.Changeset{} = ProductCatalogue.change_pricing_plan(pricing_plan)
    end
  end

  describe "watches" do
    alias Chrono.ProductCatalogue.Watch

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def watch_fixture(attrs \\ %{}) do
      {:ok, watch} =
        attrs
        |> Enum.into(@valid_attrs)
        |> ProductCatalogue.create_watch()

      watch
    end

    test "list_watches/0 returns all watches" do
      watch = watch_fixture()
      assert ProductCatalogue.list_watches() == [watch]
    end

    test "get_watch!/1 returns the watch with given id" do
      watch = watch_fixture()
      assert ProductCatalogue.get_watch!(watch.id) == watch
    end

    test "create_watch/1 with valid data creates a watch" do
      assert {:ok, %Watch{} = watch} = ProductCatalogue.create_watch(@valid_attrs)
    end

    test "create_watch/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ProductCatalogue.create_watch(@invalid_attrs)
    end

    test "update_watch/2 with valid data updates the watch" do
      watch = watch_fixture()
      assert {:ok, watch} = ProductCatalogue.update_watch(watch, @update_attrs)
      assert %Watch{} = watch
    end

    test "update_watch/2 with invalid data returns error changeset" do
      watch = watch_fixture()
      assert {:error, %Ecto.Changeset{}} = ProductCatalogue.update_watch(watch, @invalid_attrs)
      assert watch == ProductCatalogue.get_watch!(watch.id)
    end

    test "delete_watch/1 deletes the watch" do
      watch = watch_fixture()
      assert {:ok, %Watch{}} = ProductCatalogue.delete_watch(watch)
      assert_raise Ecto.NoResultsError, fn -> ProductCatalogue.get_watch!(watch.id) end
    end

    test "change_watch/1 returns a watch changeset" do
      watch = watch_fixture()
      assert %Ecto.Changeset{} = ProductCatalogue.change_watch(watch)
    end
  end
end
