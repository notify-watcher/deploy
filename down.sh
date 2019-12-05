#!/bin/bash

docker-compose -f docker-compose.yml -f docker-compose.dev.yml down

if [[ "$1" == "p" ]]; then
  echo y | docker system prune
fi
