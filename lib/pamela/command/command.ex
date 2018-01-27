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

  def get_telegram_command_by(telegram_user_id, executed) do
    Repo.all(
      from(
        c in TelegramCommand,
        where: c.telegram_user_id == ^telegram_user_id and c.executed == ^executed,
        select: c
      )
    )
  end

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

  alias Pamela.Command.TelegramCommandMessage

  @doc """
  Returns the list of telegram_command_messages.

  ## Examples

      iex> list_telegram_command_messages()
      [%TelegramCommandMessage{}, ...]

  """
  def list_telegram_command_messages do
    Repo.all(TelegramCommandMessage)
  end

  @doc """
  Gets a single telegram_command_message.

  Raises `Ecto.NoResultsError` if the Telegram command message does not exist.

  ## Examples

      iex> get_telegram_command_message!(123)
      %TelegramCommandMessage{}

      iex> get_telegram_command_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_telegram_command_message!(id), do: Repo.get!(TelegramCommandMessage, id)


  def get_telegram_command_message_by(telegram_command_update_id) do
    Repo.all(
      from(
        c in TelegramCommandMessage,
        where: c.telegram_command_update_id == ^telegram_command_update_id,
        order_by: [desc: c.inserted_at],
        select: c
      )
    )
  end

  @doc """
  Creates a telegram_command_message.

  ## Examples

      iex> create_telegram_command_message(%{field: value})
      {:ok, %TelegramCommandMessage{}}

      iex> create_telegram_command_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_telegram_command_message(attrs \\ %{}) do
    %TelegramCommandMessage{}
    |> TelegramCommandMessage.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a telegram_command_message.

  ## Examples

      iex> update_telegram_command_message(telegram_command_message, %{field: new_value})
      {:ok, %TelegramCommandMessage{}}

      iex> update_telegram_command_message(telegram_command_message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_telegram_command_message(%TelegramCommandMessage{} = telegram_command_message, attrs) do
    telegram_command_message
    |> TelegramCommandMessage.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a TelegramCommandMessage.

  ## Examples

      iex> delete_telegram_command_message(telegram_command_message)
      {:ok, %TelegramCommandMessage{}}

      iex> delete_telegram_command_message(telegram_command_message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_telegram_command_message(%TelegramCommandMessage{} = telegram_command_message) do
    Repo.delete(telegram_command_message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking telegram_command_message changes.

  ## Examples

      iex> change_telegram_command_message(telegram_command_message)
      %Ecto.Changeset{source: %TelegramCommandMessage{}}

  """
  def change_telegram_command_message(%TelegramCommandMessage{} = telegram_command_message) do
    TelegramCommandMessage.changeset(telegram_command_message, %{})
  end
end
