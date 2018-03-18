defmodule BinanceMock do
  def get_account() do
    {:ok,
     %{
       "balances" => [
         %{"asset" => "BTC", "free" => "0.07083269", "locked" => "0.00000000"},
         %{"asset" => "BNB", "free" => "1.14931839", "locked" => "0.00000000"},
         %{"asset" => "REQ", "free" => "300.00000000", "locked" => "0.00000000"},
         %{"asset" => "XRP", "free" => "1000.00000000", "locked" => "0.00000000"},
         %{"asset" => "BCPT", "free" => "3.00000000", "locked" => "0.00000000"},
         %{"asset" => "ADA", "free" => "1000.00000000", "locked" => "0.00000000"},
         %{"asset" => "XLM", "free" => "2000.00000000", "locked" => "0.00000000"}
       ]
     }}
  end

  def get_all_prices() do
    {:ok,
     [
       %Binance.SymbolPrice{price: "0.07813500", symbol: "ETHBTC"},
       %Binance.SymbolPrice{price: "0.00008706", symbol: "XRPBTC"},
       %Binance.SymbolPrice{price: "0.00002327", symbol: "ADABTC"},
       %Binance.SymbolPrice{price: "0.00003275", symbol: "XLMBTC"}
     ]}
  end

  def order_market_buy(market, amount) do
    {:ok,
     %{
       "executedQty" => Integer.to_string(amount),
       "market" => market,
       "side" => "BUY",
       "orderId" => 1
     }}
  end

  def order_market_sell(market, amount) do
    {:ok,
     %{
       "executedQty" => Integer.to_string(amount),
       "market" => market,
       "side" => "SELL",
       "orderId" => 2
     }}
  end
end
