defprotocol Exchange do
  def get_balance(self, coins)
  def get_prices(self, coins)
end
