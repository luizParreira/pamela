defmodule PamelaWeb.MessagesController do
  use Application.Web, :controller

  def handle(conn, params) do
    IO.puts params
    json(conn, %{success: true})
  end
end
