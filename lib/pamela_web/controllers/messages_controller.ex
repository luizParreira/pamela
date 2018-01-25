defmodule PamelaWeb.MessagesController do
  use PamelaWeb, :controller

  def handle(conn, params) do
    IO.inspect params
    json(conn, %{success: true})
  end
end
