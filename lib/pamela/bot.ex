defprotocol Pamela.Bot do
  def send_message(bot, user_id, message)
  def get_updates(bot, limit)
  def get_updates(bot)
end
