defmodule Colorfinity.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ColorfinityWeb.Telemetry,
      Colorfinity.Repo,
      {Ecto.Migrator,
       repos: Application.fetch_env!(:colorfinity, :ecto_repos), skip: skip_migrations?()},
      {DNSCluster, query: Application.get_env(:colorfinity, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Colorfinity.PubSub},
      # Start a worker by calling: Colorfinity.Worker.start_link(arg)
      # {Colorfinity.Worker, arg},
      # Start to serve requests, typically the last entry
      ColorfinityWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Colorfinity.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ColorfinityWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp skip_migrations?() do
    # By default, sqlite migrations are run when using a release
    System.get_env("RELEASE_NAME") == nil
  end
end
