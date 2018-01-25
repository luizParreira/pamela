defmodule PamelaWeb.Router do
  use PamelaWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/pamela", PamelaWeb do
    pipe_through :api
    post "/telegram/:token", MessagesController, :handle
  end
end
