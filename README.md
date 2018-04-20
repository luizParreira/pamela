# Pamela

Pamela is a cryptocurrency automatic portfolio rebalancing bot that works with [Binance Exchange](https://www.binance.com/) and is controlled through Telegram.

## Parts

Pamela has 2 main parts, the first is the actual Telegram bot, the one that is able to fetch updates and handle new messages from users, the second part is the rebalancing part, where the rebalancing algorithm is implemented.

### Telegram bot

The telegram bot is the part of the bot responsible for managing new updates coming from users, handling the registered commands and reacting properly. It works in a way that it receives the command and knows how to generate the necessary dialog to respond to the command and create parse the user's response to its questions.

### Commands

#### `/trade`

Trade is the command responsible for starting a new trading session:

1.  It asks you to name the current Session, so it can later refer it back to you.
2.  Asks you to list the coins that you want to trade with the base coin being the first. iex. BTC, ETH, XLM, ADA
3.  Asks the period in which you would like her to be trading between, in hours. So, if you say 3, she will be rebalancing your portfolio every 3 hours.
4.  It then prints the summary of the session you are building up and asks you to confirm.
5.  Once confirmed, she will run your portfolio through the rebalancing algorithm for the first time, and then run again within n(period inputed) hours.

#### `/halt`

Halt is the command responsible for stoping the current trading session that is going on, if there is any. In case there is no trading session running, the command won't do anything but tell you that.

### Trader

This section of pamela is the part where she has to do all the magic to be able to rebalance the user portfolio to a new % distribution and then actually execute those trades to match that % distribution upon the user's account on [Binance](https://www.binance.com/). In order to be able to rebalance the user's portfolio, Pamela implements an algorithm called [Passive Aggressive Mean-Reversion (PAMR)](http://ink.library.smu.edu.sg/cgi/viewcontent.cgi?article=3295&context=sis_research) this algorithm looks at the rate of change of the assets in question, then tries to adjust the portfolio according to the volatility of each asset and the portfolio as a whole. It is very useful when the asset is volatile but does not suffers from drastic changes upwards, because it will usually sell the asset too early if it is moving upwards, as it will try to capitalize in the gain the asset has suffered since it bought it, though this behaviour is adjustable throught the input parameters.

# Usage

In order to be able to use and deploy pamela, one needs to configure its env vars and build the project. The project was built to be private, the reason for this is that it requires sensitive API keys and secrets from the crypto exchange to be able to execute actual trades.

## Configuration

In order to configure the project, one needs:

* `TELEGRAM_TOKEN` - This is the token of the bot you create on telegram, your version of Pamela.
* `ALLOWED_USER` - Once you have your bot, its good to interact with it on your Telegram app, so that it can have access to your message and your user id, once you have your id. You can add it as an env var to this file, that way, only you will be able to execute trades with the bot.
* `API_KEY` - This is Binance's `API_KEY`;
* `SECRET_KEY` - This is Binance's `SECRET_KEY`;

## Building the project

### Dependencies

* Phoenix 1.3
* Elixir 1.6
* Postgres 9.2

### Docker (Recommended)

Make sure you have Docker installed on your machine. Once you have that, all you have to do is run:

```
# Git clone the repo or your fork
$ git clone git@github.com:luizParreira/pamela.git
$ cd pamela
$ chmod -R +x script/build
$ ./script/build
$ chmod -R +x script/start
$ ./script/start
```

### Locally

In order to build it locally, you need to have the dependencies layed out earlier installed on your machine, once you do, run these commands:

```
# Git clone the repo or your fork
$ git clone git@github.com:luizParreira/pamela.git
$ cd pamela
$ mix deps.get
$ mix ecto.setup
$ mix phx.server
```

## TODO

* Implement `/metrics` command. https://github.com/luizParreira/pamela/issues/21
* Implement backtesting and simulation capabilities, so that we can test different parameters and its behaviours
* Integrate other exchanges
* Increase test coverage
