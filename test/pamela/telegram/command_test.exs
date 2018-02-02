defmodule Pamela.Telegram.CommandTest do
  use Pamela.DataCase

  alias Pamela.Telegram
  alias Pamela.User

  describe "telegram_commands" do
    alias Pamela.Telegram.Command

    @valid_attrs %{command: "/trade", telegram_user_id: 42, message_id: 99, executed: false}
    @update_attrs %{
      executed: true
    }
    @invalid_attrs %{command: nil, telegram_user_id: nil, message_id: nil}

    def command_fixture(attrs \\ %{}) do
      {:ok, user} = User.create_telegram_user(%{username: "zezinho", id: 10})

      {:ok, message} =
        Telegram.create_message(%{
          update_id: 100,
          text: "/trade",
          type: "command",
          user_id: user.id
        })

      {:ok, command} =
        attrs
        |> Enum.into(%{@valid_attrs | message_id: message.update_id, telegram_user_id: user.id})
        |> Telegram.create_command()

      command
    end

    test "list_commands/0 returns all commands" do
      command = command_fixture()
      assert Telegram.list_commands() == [command]
    end

    test "get_command/1 returns the command with given id" do
      command = command_fixture()
      assert Telegram.get_command(command.message_id) == command
    end

    test "get_command_by/2 returns a list of commands given user_id and executed flag" do
      command = command_fixture()
      commands = Telegram.get_command_by(user_id: command.telegram_user_id, executed: false)

      assert commands === [command]

      empty_commands = Telegram.get_command_by(user_id: 100, executed: true)
      assert empty_commands === []
    end

    test "create_command/1 with valid data creates a command" do
      command = command_fixture()

      assert command.command === "/trade"
      assert command.executed === false
    end

    test "create_command/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Telegram.create_command(@invalid_attrs)
    end

    test "update_command/2 with valid data updates the command" do
      command = command_fixture()

      assert {:ok, command} = Telegram.update_command(command, @update_attrs)

      assert %Command{} = command
      assert command.executed == true
    end

    test "update_command/2 with invalid data returns error changeset" do
      command = command_fixture()

      assert {:error, %Ecto.Changeset{}} = Telegram.update_command(command, @invalid_attrs)

      assert command == Telegram.get_command(command.message_id)
    end

    test "delete_command/1 deletes the command" do
      command = command_fixture()
      assert {:ok, %Command{}} = Telegram.delete_command(command)

      assert Telegram.get_command(command.message_id) === nil
    end

    test "change_command/1 returns a command changeset" do
      command = command_fixture()
      assert %Ecto.Changeset{} = Telegram.change_command(command)
    end
  end
end
