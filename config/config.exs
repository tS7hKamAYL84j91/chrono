# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration

# Configures the endpoint
config :chrono, ChronoWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "PXHQ6CkYdk8TuBj4uxRTp9HWzI8F5f/ASZiHvtNK8DYZe43/oJUDmOiQcAFlj0JS",
  render_errors: [view: ChronoWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Chrono.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :chrono, Chrono.CMS.Repo, 
  schedule: 30 # in seconds

config :mix_docker, image: "jimandsalbrownmsncom/chrono"

config :elixir_google_spreadsheets, :client,
  request_workers: 50,
  max_demand: 100,
  max_interval: :timer.minutes(1),
  interval: 100

config :chrono, 
  recaptcha_key:  "6LeIJzwUAAAAACawWIxhl8za50WcvsaHR0-v-qOH",
  recaptcha_url: "https://www.google.com/recaptcha/api/siteverify"

config :chrono,
  main_video: "main_content_background_video"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
