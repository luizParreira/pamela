FROM elixir:1.6.0-alpine

RUN mix local.hex --force \
  && mix local.rebar --force \
  && apk --no-cache --update add postgresql-client bash git \
  && rm -rf /var/cache/apk/* \
  && mkdir /app

COPY . /app
WORKDIR /app

RUN mix deps.get

RUN echo "America/Sao_Paulo" > /etc/timezone

EXPOSE 4000

CMD ["mix", "phx.server"]
