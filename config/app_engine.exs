use Mix.Config

config :chrono, ChronoWeb.Endpoint,
  http: [port: {:system, "PORT"}],
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  check_origin: false,
  server: true

# Do not print debug messages in production
config :logger, level: :debug

config :chrono, Chrono.CMS.Repo,
  contentful_key: System.get_env("CONTENTFUL_KEY"),
  contentful_space: System.get_env("CONTENTFUL_SPACE")
