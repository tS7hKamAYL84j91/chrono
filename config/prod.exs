use Mix.Config

# For production, we often load configuration from external
# sources, such as your system environment. For this reason,
# you won't find the :http configuration below, but set inside
# ChronoWeb.Endpoint.init/2 when load_from_system_env is
# true. Any dynamic configuration should be done there.
#
# Don't forget to configure the url host to something meaningful,
# Phoenix uses this information when generating URLs.
#
# Finally, we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the mix phx.digest task
# which you typically run after static files are built.
config :chrono, ChronoWeb.Endpoint,
  load_from_system_env: true,
  url: [scheme: "https", host: "chrono6538.herokuapp.com", port: 443],
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  cache_static_manifest: "priv/static/cache_manifest.json",
  secret_key_base: System.get_env("SECRET_KEY_BASE")

# Do not print debug messages in production
config :logger, level: :debug

config :chrono, Chrono.CMS.Repo,
  contentful_key: System.get_env("CONTENTFUL_KEY"),
  contentful_space: System.get_env("CONTENTFUL_SPACE"),
  medium_url: System.get_env("MEDIUM_URL") |> Base.decode64!(),
  default_posts: System.get_env("MEDIUM_NUM_POSTS")

config :goth, json: System.get_env("GOTH") |> Base.decode64!()

config :chrono,
  gss_id: System.get_env("SPREADSHEET_ID"),
  recaptcha_secret: System.get_env("RECAPTCHA_SECRET")
