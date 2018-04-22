defmodule ChronoWeb.Router do
  use ChronoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ChronoWeb do
    pipe_through :browser 
    get "/", PageController, :index
    post "/contacts", CrmController, :create
    get "/watches", WatchController, :index

  end

  scope "/api", ChronoWeb do
    pipe_through :api
    post "/cms", CMSController, :create
  end

end
