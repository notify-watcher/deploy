#!/bin/bash

if [[ -z $HOST ]]; then
  echo "Need HOST env var"
  exit 1
fi

echo "# Copying files"
scp .env $HOST:
scp docker-compose.yml $HOST:docker-compose.notify-watcher.yml
scp docker-compose.prod.yml $HOST:docker-compose.notify-watcher.prod.yml

ssh $HOST ' \
  echo "# Pulling images" \
  && ./docker-compose-pull.sh \
  && echo "# Mounting containers" \
  && ./docker-compose-up.sh \
  && echo "# Pruning system" \
  && echo y | docker system prune \
  '
