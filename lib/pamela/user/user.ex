defmodule Pamela.User do
  @moduledoc """
  The User context.
  """

  import Ecto.Query, warn: false
  alias Pamela.Repo

  alias Pamela.User.TelegramUser

  @doc """
  Returns the list of telegram_users.

  ## Examples

      iex> list_telegram_users()
      [%TelegramUser{}, ...]

  """
  def list_telegram_users do
    Repo.all(TelegramUser)
  end

  @doc """
  Gets a single telegram_user.

  Raises `Ecto.NoResultsError` if the Telegram user does not exist.

  ## Examples

      iex> get_telegram_user!(123)
      %TelegramUser{}

      iex> get_telegram_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_telegram_user(id), do: Repo.get(TelegramUser, id)

  @doc """
  Creates a telegram_user.

  ## Examples

      iex> create_telegram_user(%{field: value})
      {:ok, %TelegramUser{}}

      iex> create_telegram_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_telegram_user(attrs \\ %{}) do
    %TelegramUser{}
    |> TelegramUser.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a telegram_user.

  ## Examples

      iex> update_telegram_user(telegram_user, %{field: new_value})
      {:ok, %TelegramUser{}}

      iex> update_telegram_user(telegram_user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_telegram_user(%TelegramUser{} = telegram_user, attrs) do
    telegram_user
    |> TelegramUser.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a TelegramUser.

  ## Examples

      iex> delete_telegram_user(telegram_user)
      {:ok, %TelegramUser{}}

      iex> delete_telegram_user(telegram_user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_telegram_user(%TelegramUser{} = telegram_user) do
    Repo.delete(telegram_user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking telegram_user changes.

  ## Examples

      iex> change_telegram_user(telegram_user)
      %Ecto.Changeset{source: %TelegramUser{}}

  """
  def change_telegram_user(%TelegramUser{} = telegram_user) do
    TelegramUser.changeset(telegram_user, %{})
  end
end
