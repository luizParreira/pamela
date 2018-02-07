defmodule Pamela.TelegramTest do
  use Pamela.DataCase

  alias Pamela.Telegram
  alias Pamela.User

  describe "telegram_messages" do
    alias Pamela.Telegram.Message

    @valid_attrs %{text: "some text", type: "some type", user_id: 42, update_id: 100}
    @update_attrs %{text: "some updated text", type: "some updated type"}
    @invalid_attrs %{text: nil, type: nil, user_id: nil}

    def message_fixture(attrs \\ %{}) do
      {:ok, user} = User.create_telegram_user(%{username: "zezinho", id: 10})

      {:ok, message} =
        attrs
        |> Enum.into(%{@valid_attrs | user_id: user.id})
        |> Telegram.create_message()

      message
    end

    test "list_messages/0 returns all messages" do
      message = message_fixture()
      assert Telegram.list_messages() == [message]
    end

    test "get_message/1 returns the message with given id" do
      message = message_fixture()
      assert Telegram.get_message(message.update_id) == message
    end

    test "create_message/1 with valid data creates a message" do
      assert %Message{} = message = message_fixture()
      assert message.text == "some text"
      assert message.type == "some type"
    end

    test "create_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Telegram.create_message(@invalid_attrs)
    end

    test "update_message/2 with valid data updates the message" do
      message = message_fixture()
      assert {:ok, message} = Telegram.update_message(message, @update_attrs)
      assert %Message{} = message
      assert message.text == "some updated text"
      assert message.type == "some updated type"
    end

    test "update_message/2 with invalid data returns error changeset" do
      message = message_fixture()
      assert {:error, %Ecto.Changeset{}} = Telegram.update_message(message, @invalid_attrs)
      assert message == Telegram.get_message(message.update_id)
    end

    test "delete_message/1 deletes the message" do
      message = message_fixture()
      assert {:ok, %Message{}} = Telegram.delete_message(message)
      assert Telegram.get_message(message.update_id) === nil
    end

    test "change_message/1 returns a message changeset" do
      message = message_fixture()
      assert %Ecto.Changeset{} = Telegram.change_message(message)
    end
  end
end
