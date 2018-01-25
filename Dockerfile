FROM elixir:1.6.0-alpine

RUN mix local.hex --force \
  && mix local.rebar --force \
  && apk --no-cache --update add postgresql-client bash \
  && rm -rf /var/cache/apk/* \
  && mkdir /app

COPY . /app
WORKDIR /app

RUN mix deps.get

EXPOSE 4000

CMD ["mix", "phx.server"]
