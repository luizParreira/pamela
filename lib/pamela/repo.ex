defmodule Pamela.Repo do
  use Ecto.Repo,
    otp_app: :pamela,
    adapter: Ecto.Adapters.Postgres
end
