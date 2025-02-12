defmodule Habits.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      HabitsWeb.Telemetry,
      Habits.Repo,
      {DNSCluster, query: Application.get_env(:habits, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Habits.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Habits.Finch},
      # Start a worker by calling: Habits.Worker.start_link(arg)
      # {Habits.Worker, arg},
      # Start to serve requests, typically the last entry
      HabitsWeb.Endpoint,
    ] ++ task_notifier()

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Habits.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp task_notifier do
    if Mix.env() == :test do
      []
    else
      [Habits.TaskNotifier]
    end
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    HabitsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
