defmodule Chrono.Update do
  use GenServer
  import Ecto.Query

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    schedule_work() # Schedule work to be performed at some point
    {:ok, state}
  end

  def handle_info(:work, state) do
    # Do the work you desire here
    updatewatchdb()
    schedule_work() # Reschedule once more
    {:noreply, state}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 24 * 60 * 60 * 1000) # In 2 hours
  end

    defp updatewatchdb() do
    content = Contentful.Delivery.content_type(Application.get_env(:chrono,:contentful_space), Application.get_env(:chrono,:contentful_key), "watch")
    watch = Chrono.Repo.get!(Chrono.Watch, 1)
    if  content["sys"]["updatedAt"] != watch.name do
      watch 
        |>  Ecto.Changeset.change( name: content["sys"]["updatedAt"] ) 
        |> Chrono.Repo.update()

      q = from w in Chrono.Watch, where: w.id != 1
      Chrono.Repo.delete_all(q)
      allwatches = Contentful.Delivery.entries(Application.get_env(:chrono,:contentful_space), Application.get_env(:chrono,:contentful_key), %{"content_type" => "watch"} )
      for w <- allwatches do
        changeset =
          %Chrono.Watch{}
          |> Chrono.Watch.changeset(%{name: w["fields"]["name"], description: w["fields"]["description"] , category: ["fields"]["category"] })
          |> Chrono.Repo.insert
      end

    end
  end
end