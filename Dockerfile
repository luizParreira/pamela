FROM postgres:11.5-alpine AS postgres

FROM elixir:1.9.1-alpine
EXPOSE 4000

ENV APP_PATH /app

RUN mix local.hex --force \
  && mix local.rebar --force \
  && apk --no-cache --update add bash alpine-sdk coreutils curl postgresql-client \
  && rm -rf /var/cache/apk/* \
  && mkdir $APP_PATH

COPY --from=postgres /usr/local/bin/pg_dump /usr/local/bin/pg_dump

COPY . $APP_PATH
WORKDIR $APP_PATH

RUN mix deps.get

RUN echo "America/Sao_Paulo" > /etc/timezone
CMD ["mix", "phx.server"]
