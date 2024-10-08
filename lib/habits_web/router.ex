defmodule HabitsWeb.Router do
  use HabitsWeb, :router

  import HabitsWeb.Authentication, only: [fetch_current_user: 2, require_authenticated_user: 2]

  pipeline :api do
    plug :fetch_session
    plug :accepts, ["json"]
  end

  pipeline :user_api do
    plug :fetch_current_user
    plug :require_authenticated_user
  end

  scope "/", HabitsWeb do
    pipe_through :api

    resources "/users", UserController, only: [:create]
    resources "/sessions", SessionController, only: [:create], singleton: true
  end

  scope "/", HabitsWeb do
    pipe_through [:api, :user_api]

    resources "/users", UserController, only: [:update, :show]
    resources "/sessions", SessionController, only: [:delete, :show], singleton: true

    resources "/chains", ChainController, only: [:show, :index, :create, :update, :delete]
    resources "/chains/order", ChainOrderController, only: [:create]

    resources "/metrics", MetricController, only: [:index, :create, :delete]
    resources "/metrics_history", MetricsHistoryController, only: [:index, :create, :delete]
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:habits, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: HabitsWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
