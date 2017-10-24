defmodule Chrono.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    :chrono
    |> Application.get_all_env
    |> Keyword.keys
    |> Enum.map(&update_env_config(:chrono,&1))


    # Define workers and child supervisors to be supervised
    children = [
      # Start the endpoint when the application starts
      supervisor(ChronoWeb.Endpoint, []),
      # Start your own worker by calling: Chrono.Worker.start_link(arg1, arg2, arg3)
      # worker(Chrono.Worker, [arg1, arg2, arg3]),
      worker(Chrono.Contentful.Repo, []),
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Chrono.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ChronoWeb.Endpoint.config_change(changed, removed)
    :ok
  end


  def update_env_config(app, config) do
    Application.get_env(app, config)
    |> Enum.map(&get_env_config/1)
    |> (&Application.put_env(app, config, &1)).()
  end

  def get_env_config({key, {:system, env_var}}), do: {key, System.get_env(env_var)}
  def get_env_config(var), do: var

end