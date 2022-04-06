defmodule FitlogWeb.Router do
  use FitlogWeb, :router

  pipeline :auth do
    plug :accepts, ["json"]
    plug :fetch_session
    plug Fitlog.Users.Pipeline
  end

  pipeline :browser do
    plug :fetch_session
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", FitlogWeb do
    pipe_through :auth

    get "/user", UserController, :show
    resources "/reports", ReportController, except: [:new, :edit]
  end

  scope "/auth", FitlogWeb do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end
end
