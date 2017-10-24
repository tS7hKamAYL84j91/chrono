use Mix.Config

config :chrono, ChronoWeb.Endpoint,
  http: [port: {:system, "PORT"}],
  check_origin: false,
  server: true

# Do not print debug messages in production
config :logger, level: :info

config :chrono, Chrono.Contentful.Repo,
  contentful_key: {:system, "CONTENTFUL_KEY"},
  contentful_space: {:system, "CONTENTFUL_SPACE"}