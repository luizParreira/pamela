defmodule Pamela.Telegram do
  @moduledoc """
  The Telegram context.
  """

  import Ecto.Query, warn: false
  alias Pamela.Repo

  alias Pamela.Telegram.Message

  @doc """
  Returns the list of messages.

  ## Examples

      iex> list_messages()
      [%Message{}, ...]

  """
  def list_messages do
    Repo.all(Message)
  end

  @doc """
  Gets a single message.

  Raises `nil` if the Message does not exist.

  ## Examples

      iex> get_message(123)
      %Message{}

      iex> get_message(456)
      nil

  """
  def get_message(id), do: Repo.get(Message, id)

  @doc """
  Creates a message.

  ## Examples

      iex> create_message(%{field: value})
      {:ok, %Message{}}

      iex> create_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a message.

  ## Examples

      iex> update_message(message, %{field: new_value})
      {:ok, %Message{}}

      iex> update_message(message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_message(%Message{} = message, attrs) do
    message
    |> Message.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Message.

  ## Examples

      iex> delete_message(message)
      {:ok, %Message{}}

      iex> delete_message(message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_message(%Message{} = message) do
    Repo.delete(message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking message changes.

  ## Examples

      iex> change_message(message)
      %Ecto.Changeset{source: %Message{}}

  """
  def change_message(%Message{} = message) do
    Message.changeset(message, %{})
  end

  alias Pamela.Telegram.Command

  @doc """
  Returns the list of commands.

  ## Examples

      iex> list_commands()
      [%Command{}, ...]

  """
  def list_commands do
    Repo.all(Command)
  end

  @doc """
  Gets a single command.

  Returns `nil` if the Telegram command does not exist.

  ## Examples

      iex> get_command(123)
      %Command{}

      iex> get_command(456)
      nil

  """
  def get_command(id), do: Repo.get(Command, id)

  @doc """
  Gets a list of commands filtered by `telegram_user_id` and `executed` flag.

  Returns a list of commands ordered descending by `inserted_at`.

  Returns an empty list if no records with such id and flag exist

  ## Examples

      iex> get_command_by(123)
      [%Command{}]

      iex> get_command_by(456)
      []

  """
  def get_command_by(user_id: user_id, executed: executed) do
    Repo.all(
      from(
        c in Command,
        where: c.telegram_user_id == ^user_id and c.executed == ^executed,
        select: c,
        order_by: [desc: c.inserted_at]
      )
    )
  end

  def get_command_by(_), do: []

  @doc """
  Creates a command.

  ## Examples

      iex> create_command(%{field: value})
      {:ok, %Command{}}

      iex> create_command(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_command(attrs \\ %{}) do
    %Command{}
    |> Command.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a command.

  ## Examples

      iex> update_command(command, %{field: new_value})
      {:ok, %Command{}}

      iex> update_command(command, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_command(%Command{} = command, attrs) do
    command
    |> Command.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Command.

  ## Examples

      iex> delete_command(command)
      {:ok, %Command{}}

      iex> delete_command(command)
      {:error, %Ecto.Changeset{}}

  """
  def delete_command(%Command{} = command) do
    Repo.delete(command)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking command changes.

  ## Examples

      iex> change_command(command)
      %Ecto.Changeset{source: %Command{}}

  """
  def change_command(%Command{} = command) do
    Command.changeset(command, %{})
  end

  alias Pamela.Telegram.CommandMessage

  @doc """
  Returns the list of command_messages.

  ## Examples

      iex> list_command_messages()
      [%CommandMessage{}, ...]

  """
  def list_command_messages do
    Repo.all(CommandMessage)
  end

  @doc """
  Gets a single command_message.

  Raises `Ecto.NoResultsError` if the Telegram command message does not exist.

  ## Examples

      iex> get_command_message!(123)
      %CommandMessage{}

      iex> get_command_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_command_message!(id), do: Repo.get!(CommandMessage, id)

  @doc """
  Gets a list of commands filtered by `command_update_id`.

  Returns a list of commands ordered descending by `inserted_at`.

  Returns an empty list if no records with such id and flag exist

  ## Examples

      iex> get_command_message_by(123)
      [%CommandMessage{}]

      iex> get_command_message_by(456)
      []

  """
  def get_command_message_by(telegram_command_update_id: command_update_id) do
    Repo.all(
      from(
        c in CommandMessage,
        where: c.telegram_command_update_id == ^command_update_id,
        order_by: [desc: c.inserted_at],
        select: c
      )
    )
  end

  def create_command_message(id, message) do
    create_command_message(%{
      telegram_command_update_id: id,
      message: message
    })
  end

  @doc """
  Creates a command_message.

  ## Examples

      iex> create_command_message(%{field: value})
      {:ok, %CommandMessage{}}

      iex> create_command_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_command_message(attrs \\ %{}) do
    %CommandMessage{}
    |> CommandMessage.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a command_message.

  ## Examples

      iex> update_command_message(command_message, %{field: new_value})
      {:ok, %CommandMessage{}}

      iex> update_command_message(command_message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_command_message(%CommandMessage{} = command_message, attrs) do
    command_message
    |> CommandMessage.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a CommandMessage.

  ## Examples

      iex> delete_command_message(command_message)
      {:ok, %CommandMessage{}}

      iex> delete_command_message(command_message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_command_message(%CommandMessage{} = command_message) do
    Repo.delete(command_message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking command_message changes.

  ## Examples

      iex> change_command_message(command_message)
      %Ecto.Changeset{source: %CommandMessage{}}

  """
  def change_command_message(%CommandMessage{} = command_message) do
    CommandMessage.changeset(command_message, %{})
  end
end
