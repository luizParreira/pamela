defmodule PamelaWeb.Router do
  use PamelaWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PamelaWeb do
    pipe_through :api

    token = Application.get_env(:pamela, :bot_token)

    post "/pamela/#{token}", PamelaWeb.MessagesController
  end
end
