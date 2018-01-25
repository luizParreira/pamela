defmodule PamelaWeb.Router do
  use PamelaWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PamelaWeb do
    pipe_through :api
  end
end
