defmodule Chrono.ProductCatalogue do
  @moduledoc """
  The ProductCatalogue context.
  """

  import Ecto.Query, warn: false
  alias Chrono.Repo

  alias Chrono.ProductCatalogue.PricingPlan

  @doc """
  Returns the list of pricingplans.

  ## Examples

      iex> list_pricingplans()
      [%PricingPlan{}, ...]

  """
  def list_pricingplans do
    Repo.all(PricingPlan)
  end

  @doc """
  Gets a single pricing_plan.

  Raises `Ecto.NoResultsError` if the Pricing plan does not exist.

  ## Examples

      iex> get_pricing_plan!(123)
      %PricingPlan{}

      iex> get_pricing_plan!(456)
      ** (Ecto.NoResultsError)

  """
  def get_pricing_plan!(id), do: Repo.get!(PricingPlan, id)

  @doc """
  Creates a pricing_plan.

  ## Examples

      iex> create_pricing_plan(%{field: value})
      {:ok, %PricingPlan{}}

      iex> create_pricing_plan(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_pricing_plan(attrs \\ %{}) do
    %PricingPlan{}
    |> PricingPlan.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a pricing_plan.

  ## Examples

      iex> update_pricing_plan(pricing_plan, %{field: new_value})
      {:ok, %PricingPlan{}}

      iex> update_pricing_plan(pricing_plan, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_pricing_plan(%PricingPlan{} = pricing_plan, attrs) do
    pricing_plan
    |> PricingPlan.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a PricingPlan.

  ## Examples

      iex> delete_pricing_plan(pricing_plan)
      {:ok, %PricingPlan{}}

      iex> delete_pricing_plan(pricing_plan)
      {:error, %Ecto.Changeset{}}

  """
  def delete_pricing_plan(%PricingPlan{} = pricing_plan) do
    Repo.delete(pricing_plan)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking pricing_plan changes.

  ## Examples

      iex> change_pricing_plan(pricing_plan)
      %Ecto.Changeset{source: %PricingPlan{}}

  """
  def change_pricing_plan(%PricingPlan{} = pricing_plan) do
    PricingPlan.changeset(pricing_plan, %{})
  end

  alias Chrono.ProductCatalogue.Watch

  @doc """
  Returns the list of watches.

  ## Examples

      iex> list_watches()
      [%Watch{}, ...]

  """
  def list_watches do
    Repo.all(Watch)
  end

  @doc """
  Gets a single watch.

  Raises `Ecto.NoResultsError` if the Watch does not exist.

  ## Examples

      iex> get_watch!(123)
      %Watch{}

      iex> get_watch!(456)
      ** (Ecto.NoResultsError)

  """
  def get_watch!(id), do: Repo.get!(Watch, id)

  @doc """
  Creates a watch.

  ## Examples

      iex> create_watch(%{field: value})
      {:ok, %Watch{}}

      iex> create_watch(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_watch(attrs \\ %{}) do
    %Watch{}
    |> Watch.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a watch.

  ## Examples

      iex> update_watch(watch, %{field: new_value})
      {:ok, %Watch{}}

      iex> update_watch(watch, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_watch(%Watch{} = watch, attrs) do
    watch
    |> Watch.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Watch.

  ## Examples

      iex> delete_watch(watch)
      {:ok, %Watch{}}

      iex> delete_watch(watch)
      {:error, %Ecto.Changeset{}}

  """
  def delete_watch(%Watch{} = watch) do
    Repo.delete(watch)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking watch changes.

  ## Examples

      iex> change_watch(watch)
      %Ecto.Changeset{source: %Watch{}}

  """
  def change_watch(%Watch{} = watch) do
    Watch.changeset(watch, %{})
  end
end
