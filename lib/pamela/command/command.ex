defmodule Pamela.Command do
  @moduledoc """
  The Command context.
  """

  import Ecto.Query, warn: false
  alias Pamela.Repo

  alias Pamela.Command.TelegramCommand

  @doc """
  Returns the list of telegram_commands.

  ## Examples

      iex> list_telegram_commands()
      [%TelegramCommand{}, ...]

  """
  def list_telegram_commands do
    Repo.all(TelegramCommand)
  end

  @doc """
  Gets a single telegram_command.

  Raises `Ecto.NoResultsError` if the Telegram command does not exist.

  ## Examples

      iex> get_telegram_command!(123)
      %TelegramCommand{}

      iex> get_telegram_command!(456)
      nil

  """
  def get_telegram_command(id), do: Repo.get(TelegramCommand, id)

  @doc """
  Creates a telegram_command.

  ## Examples

      iex> create_telegram_command(%{field: value})
      {:ok, %TelegramCommand{}}

      iex> create_telegram_command(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_telegram_command(attrs \\ %{}) do
    %TelegramCommand{}
    |> TelegramCommand.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a telegram_command.

  ## Examples

      iex> update_telegram_command(telegram_command, %{field: new_value})
      {:ok, %TelegramCommand{}}

      iex> update_telegram_command(telegram_command, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_telegram_command(%TelegramCommand{} = telegram_command, attrs) do
    telegram_command
    |> TelegramCommand.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a TelegramCommand.

  ## Examples

      iex> delete_telegram_command(telegram_command)
      {:ok, %TelegramCommand{}}

      iex> delete_telegram_command(telegram_command)
      {:error, %Ecto.Changeset{}}

  """
  def delete_telegram_command(%TelegramCommand{} = telegram_command) do
    Repo.delete(telegram_command)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking telegram_command changes.

  ## Examples

      iex> change_telegram_command(telegram_command)
      %Ecto.Changeset{source: %TelegramCommand{}}

  """
  def change_telegram_command(%TelegramCommand{} = telegram_command) do
    TelegramCommand.changeset(telegram_command, %{})
  end
end
