defmodule Pamela.UserTest do
  use Pamela.DataCase

  alias Pamela.User

  describe "telegram_users" do
    alias Pamela.User.TelegramUser

    @valid_attrs %{
      first_name: "some first_name",
      id: 42,
      last_name: "some last_name",
      username: "some username"
    }
    @update_attrs %{
      first_name: "some updated first_name",
      id: 43,
      last_name: "some updated last_name",
      username: "some updated username"
    }
    @invalid_attrs %{first_name: nil, id: nil, last_name: nil, username: nil}

    def telegram_user_fixture(attrs \\ %{}) do
      {:ok, telegram_user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> User.create_telegram_user()

      telegram_user
    end

    test "list_telegram_users/0 returns all telegram_users" do
      telegram_user = telegram_user_fixture()
      assert User.list_telegram_users() == [telegram_user]
    end

    test "get_telegram_user/1 returns the telegram_user with given id" do
      telegram_user = telegram_user_fixture()
      assert User.get_telegram_user(telegram_user.id) == telegram_user
    end

    test "create_telegram_user/1 with valid data creates a telegram_user" do
      assert {:ok, %TelegramUser{} = telegram_user} = User.create_telegram_user(@valid_attrs)
      assert telegram_user.first_name == "some first_name"
      assert telegram_user.id == 42
      assert telegram_user.last_name == "some last_name"
      assert telegram_user.username == "some username"
    end

    test "create_telegram_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = User.create_telegram_user(@invalid_attrs)
    end

    test "update_telegram_user/2 with valid data updates the telegram_user" do
      telegram_user = telegram_user_fixture()
      assert {:ok, telegram_user} = User.update_telegram_user(telegram_user, @update_attrs)
      assert %TelegramUser{} = telegram_user
      assert telegram_user.first_name == "some updated first_name"
      assert telegram_user.id == 43
      assert telegram_user.last_name == "some updated last_name"
      assert telegram_user.username == "some updated username"
    end

    test "update_telegram_user/2 with invalid data returns error changeset" do
      telegram_user = telegram_user_fixture()

      assert {:error, %Ecto.Changeset{}} =
               User.update_telegram_user(telegram_user, @invalid_attrs)

      assert telegram_user == User.get_telegram_user(telegram_user.id)
    end

    test "delete_telegram_user/1 deletes the telegram_user" do
      telegram_user = telegram_user_fixture()
      assert {:ok, %TelegramUser{}} = User.delete_telegram_user(telegram_user)
      assert User.get_telegram_user(telegram_user.id) == nil
    end

    test "change_telegram_user/1 returns a telegram_user changeset" do
      telegram_user = telegram_user_fixture()
      assert %Ecto.Changeset{} = User.change_telegram_user(telegram_user)
    end
  end
end
