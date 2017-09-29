defmodule ChronoWeb.Router do
  use ChronoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Chrono.Plugs.SetUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ChronoWeb do
    pipe_through :browser 
    get "/", PageController, :index
  end

  scope "/auth", ChronoWeb do
    pipe_through :browser
    get "/signout", AuthController, :delete
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :new
    resources "/registration", RegistrationController, only: [:new, :create]
  end

  # Other scopes may use custom stacks.
  # scope "/api", ChronoWeb do
  #   pipe_through :api
  # end
end
