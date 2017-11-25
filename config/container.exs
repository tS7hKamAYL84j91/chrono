use Mix.Config

config :chrono, ChronoWeb.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [host: "${HOST}", port: "${PORT}"],
  secret_key_base: "${SECRET_KEY_BASE}",
  check_origin: false,
  server: true

# Do not print debug messages in production
config :logger, level: :debug

config :chrono, Chrono.CMS.Repo,
  contentful_key: "${CONTENTFUL_KEY}",
  contentful_space: "${CONTENTFUL_SPACE}"