defmodule Pamela.Telegram.CommandMessageTest do
  use Pamela.DataCase
  alias Pamela.Telegram
  alias Pamela.User

  describe "command_messages" do
    alias Pamela.Telegram.CommandMessage

    @valid_attrs %{message: "some message", telegram_command_update_id: 42}
    @update_attrs %{message: "some updated message"}
    @invalid_attrs %{message: nil, telegram_command_update_id: nil}

    def command_message_fixture(attrs \\ %{}) do
      {:ok, user} = User.create_telegram_user(%{username: "zezinho", id: 10})

      {:ok, message} =
        Telegram.create_message(%{
          update_id: 100,
          text: "/trade",
          type: "command",
          user_id: user.id
        })

      {:ok, command} =
        Telegram.create_command(%{
          command: "/trade",
          message_id: message.update_id,
          telegram_user_id: user.id,
          executed: false
        })

      {:ok, command_message} =
        attrs
        |> Enum.into(%{@valid_attrs | telegram_command_update_id: command.message_id})
        |> Telegram.create_command_message()

      command_message
    end

    test "list_command_messages/0 returns all command_messages" do
      command_message = command_message_fixture()
      assert Telegram.list_command_messages() == [command_message]
    end

    test "get_command_message/1 returns the command_message with given id" do
      command_message = command_message_fixture()

      assert Telegram.get_command_message!(command_message.id) == command_message
    end

    test "get_command_message_by/2 returns a list of commands messages given command id" do
      command_message = command_message_fixture()

      commands =
        Telegram.get_command_message_by(
          telegram_command_update_id: command_message.telegram_command_update_id
        )

      assert commands === [command_message]

      empty_commands = Telegram.get_command_by(telegram_command_update_id: 100)
      assert empty_commands === []
    end

    test "create_command_message/1 with valid data creates a command_message" do
      assert %CommandMessage{} = command_message = command_message_fixture()

      assert command_message.message == "some message"
    end

    test "create_command_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Telegram.create_command_message(@invalid_attrs)
    end

    test "update_command_message/2 with valid data updates the command_message" do
      command_message = command_message_fixture()

      assert {:ok, command_message} =
               Telegram.update_command_message(command_message, @update_attrs)

      assert %CommandMessage{} = command_message
      assert command_message.message == "some updated message"
    end

    test "update_command_message/2 with invalid data returns error changeset" do
      command_message = command_message_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Telegram.update_command_message(command_message, @invalid_attrs)

      assert command_message == Telegram.get_command_message!(command_message.id)
    end

    test "delete_command_message/1 deletes the command_message" do
      command_message = command_message_fixture()

      assert {:ok, %CommandMessage{}} = Telegram.delete_command_message(command_message)

      assert_raise Ecto.NoResultsError, fn ->
        Telegram.get_command_message!(command_message.id)
      end
    end

    test "change_command_message/1 returns a command_message changeset" do
      command_message = command_message_fixture()
      assert %Ecto.Changeset{} = Telegram.change_command_message(command_message)
    end
  end
end
