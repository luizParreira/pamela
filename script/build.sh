#!/bin/bash

docker-compose build && \
  docker-compose run bot mix deps.get && \
  docker-compose run bot mix ecto.setup
