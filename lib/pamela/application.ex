defmodule Pamela.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    user_id = Application.get_env(:pamela, :allowed_user)

    rebalance_data =
      case Trading.get_session_by(user_id, true) do
        session -> {session, Trading.get_period_by(session: session)}
        _value -> {nil, nil}
      end

    args =
      case rebalance_data do
        {nil, nil} -> []
        {session, period} -> [session, period]
      end

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(Pamela.Repo, []),
      # Start the endpoint when the application starts
      supervisor(PamelaWeb.Endpoint, []),
      # Start your own worker by calling: Pamela.Worker.start_link(arg1, arg2, arg3)
      # worker(Pamela.Worker, [arg1, arg2, arg3]),
      worker(Pamela.PeriodicTask, []),
      worker(Pamela.Trader.Rebalance, args)
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
