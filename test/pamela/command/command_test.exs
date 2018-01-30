defmodule Pamela.CommandTest do
  use Pamela.DataCase

  alias Pamela.Command

  describe "telegram_commands" do
    alias Pamela.Command.TelegramCommand

    @valid_attrs %{command: "some command", telegram_user_id: 42, update_id: 42}
    @update_attrs %{command: "some updated command", telegram_user_id: 43, update_id: 43}
    @invalid_attrs %{command: nil, telegram_user_id: nil, update_id: nil}

    def telegram_command_fixture(attrs \\ %{}) do
      {:ok, telegram_command} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Command.create_telegram_command()

      telegram_command
    end

    test "list_telegram_commands/0 returns all telegram_commands" do
      telegram_command = telegram_command_fixture()
      assert Command.list_telegram_commands() == [telegram_command]
    end

    test "get_telegram_command!/1 returns the telegram_command with given id" do
      telegram_command = telegram_command_fixture()
      assert Command.get_telegram_command!(telegram_command.id) == telegram_command
    end

    test "create_telegram_command/1 with valid data creates a telegram_command" do
      assert {:ok, %TelegramCommand{} = telegram_command} = Command.create_telegram_command(@valid_attrs)
      assert telegram_command.command == "some command"
      assert telegram_command.telegram_user_id == 42
      assert telegram_command.update_id == 42
    end

    test "create_telegram_command/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Command.create_telegram_command(@invalid_attrs)
    end

    test "update_telegram_command/2 with valid data updates the telegram_command" do
      telegram_command = telegram_command_fixture()
      assert {:ok, telegram_command} = Command.update_telegram_command(telegram_command, @update_attrs)
      assert %TelegramCommand{} = telegram_command
      assert telegram_command.command == "some updated command"
      assert telegram_command.telegram_user_id == 43
      assert telegram_command.update_id == 43
    end

    test "update_telegram_command/2 with invalid data returns error changeset" do
      telegram_command = telegram_command_fixture()
      assert {:error, %Ecto.Changeset{}} = Command.update_telegram_command(telegram_command, @invalid_attrs)
      assert telegram_command == Command.get_telegram_command!(telegram_command.id)
    end

    test "delete_telegram_command/1 deletes the telegram_command" do
      telegram_command = telegram_command_fixture()
      assert {:ok, %TelegramCommand{}} = Command.delete_telegram_command(telegram_command)
      assert_raise Ecto.NoResultsError, fn -> Command.get_telegram_command!(telegram_command.id) end
    end

    test "change_telegram_command/1 returns a telegram_command changeset" do
      telegram_command = telegram_command_fixture()
      assert %Ecto.Changeset{} = Command.change_telegram_command(telegram_command)
    end
  end

  describe "telegram_command_messages" do
    alias Pamela.Command.TelegramCommandMessage

    @valid_attrs %{message: "some message", telegram_command_update_id: 42}
    @update_attrs %{message: "some updated message", telegram_command_update_id: 43}
    @invalid_attrs %{message: nil, telegram_command_update_id: nil}

    def telegram_command_message_fixture(attrs \\ %{}) do
      {:ok, telegram_command_message} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Command.create_telegram_command_message()

      telegram_command_message
    end

    test "list_telegram_command_messages/0 returns all telegram_command_messages" do
      telegram_command_message = telegram_command_message_fixture()
      assert Command.list_telegram_command_messages() == [telegram_command_message]
    end

    test "get_telegram_command_message!/1 returns the telegram_command_message with given id" do
      telegram_command_message = telegram_command_message_fixture()
      assert Command.get_telegram_command_message!(telegram_command_message.id) == telegram_command_message
    end

    test "create_telegram_command_message/1 with valid data creates a telegram_command_message" do
      assert {:ok, %TelegramCommandMessage{} = telegram_command_message} = Command.create_telegram_command_message(@valid_attrs)
      assert telegram_command_message.message == "some message"
      assert telegram_command_message.telegram_command_update_id == 42
    end

    test "create_telegram_command_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Command.create_telegram_command_message(@invalid_attrs)
    end

    test "update_telegram_command_message/2 with valid data updates the telegram_command_message" do
      telegram_command_message = telegram_command_message_fixture()
      assert {:ok, telegram_command_message} = Command.update_telegram_command_message(telegram_command_message, @update_attrs)
      assert %TelegramCommandMessage{} = telegram_command_message
      assert telegram_command_message.message == "some updated message"
      assert telegram_command_message.telegram_command_update_id == 43
    end

    test "update_telegram_command_message/2 with invalid data returns error changeset" do
      telegram_command_message = telegram_command_message_fixture()
      assert {:error, %Ecto.Changeset{}} = Command.update_telegram_command_message(telegram_command_message, @invalid_attrs)
      assert telegram_command_message == Command.get_telegram_command_message!(telegram_command_message.id)
    end

    test "delete_telegram_command_message/1 deletes the telegram_command_message" do
      telegram_command_message = telegram_command_message_fixture()
      assert {:ok, %TelegramCommandMessage{}} = Command.delete_telegram_command_message(telegram_command_message)
      assert_raise Ecto.NoResultsError, fn -> Command.get_telegram_command_message!(telegram_command_message.id) end
    end

    test "change_telegram_command_message/1 returns a telegram_command_message changeset" do
      telegram_command_message = telegram_command_message_fixture()
      assert %Ecto.Changeset{} = Command.change_telegram_command_message(telegram_command_message)
    end
  end
end