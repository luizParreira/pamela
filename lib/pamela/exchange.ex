defprotocol Exchange do
  def get_balance(coins)
  def get_prices(coins)
end
