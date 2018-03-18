defmodule Pamela.Telegram.Bot do
  defstruct []
  alias Pamela.Telegram

  def send_message(user_id, message) do
    Pamela.Bot.send_message(%Telegram.Bot{}, user_id, message)
  end

  def get_updates() do
    Pamela.Bot.get_updates(%Telegram.Bot{})
  end

  def get_updates(limit) do
    Pamela.Bot.get_updates(%Telegram.Bot{}, limit)
  end
end

defimpl Pamela.Bot, for: Pamela.Telegram.Bot do
  alias Pamela.Telegram

  @telegram_client Application.get_env(:pamela, :telegram_client)

  def send_message(%Telegram.Bot{}, id, message) do
    @telegram_client.send_message(id, message)
  end

  def get_updates(%Telegram.Bot{}) do
    @telegram_client.get_updates()
  end

  def get_updates(%Telegram.Bot{}, limit) do
    @telegram_client.get_updates(limit: limit)
  end
end
