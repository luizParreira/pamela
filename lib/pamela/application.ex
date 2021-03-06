defmodule Pamela.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    message_handler = fn -> Pamela.MessageHandler.handle() end
    rebalance_handler = fn -> Pamela.Trader.rebalance() end

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(Pamela.Repo, []),
      # Start the endpoint when the application starts
      supervisor(PamelaWeb.Endpoint, []),
      # Start your own worker by calling: Pamela.Worker.start_link(arg1, arg2, arg3)
      # worker(Pamela.Worker, [arg1, arg2, arg3]),
      worker(Pamela.PeriodicTask, [%{task: message_handler}], id: :message_handler),
      worker(Pamela.PeriodicTask, [%{task: rebalance_handler}], id: :rebalance_handler)
      # worker(Pamela.Trader.RebalanceTask, args)
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Pamela.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    PamelaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
