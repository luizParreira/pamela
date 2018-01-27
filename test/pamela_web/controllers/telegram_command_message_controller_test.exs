defmodule PamelaWeb.TelegramCommandMessageControllerTest do
  use PamelaWeb.ConnCase

  alias Pamela.Command
  alias Pamela.Command.TelegramCommandMessage

  @create_attrs %{message: "some message", telegram_command_id: 42}
  @update_attrs %{message: "some updated message", telegram_command_id: 43}
  @invalid_attrs %{message: nil, telegram_command_id: nil}

  def fixture(:telegram_command_message) do
    {:ok, telegram_command_message} = Command.create_telegram_command_message(@create_attrs)
    telegram_command_message
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all telegram_command_messages", %{conn: conn} do
      conn = get conn, telegram_command_message_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create telegram_command_message" do
    test "renders telegram_command_message when data is valid", %{conn: conn} do
      conn = post conn, telegram_command_message_path(conn, :create), telegram_command_message: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, telegram_command_message_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "message" => "some message",
        "telegram_command_id" => 42}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, telegram_command_message_path(conn, :create), telegram_command_message: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update telegram_command_message" do
    setup [:create_telegram_command_message]

    test "renders telegram_command_message when data is valid", %{conn: conn, telegram_command_message: %TelegramCommandMessage{id: id} = telegram_command_message} do
      conn = put conn, telegram_command_message_path(conn, :update, telegram_command_message), telegram_command_message: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, telegram_command_message_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "message" => "some updated message",
        "telegram_command_id" => 43}
    end

    test "renders errors when data is invalid", %{conn: conn, telegram_command_message: telegram_command_message} do
      conn = put conn, telegram_command_message_path(conn, :update, telegram_command_message), telegram_command_message: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete telegram_command_message" do
    setup [:create_telegram_command_message]

    test "deletes chosen telegram_command_message", %{conn: conn, telegram_command_message: telegram_command_message} do
      conn = delete conn, telegram_command_message_path(conn, :delete, telegram_command_message)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, telegram_command_message_path(conn, :show, telegram_command_message)
      end
    end
  end

  defp create_telegram_command_message(_) do
    telegram_command_message = fixture(:telegram_command_message)
    {:ok, telegram_command_message: telegram_command_message}
  end
end
