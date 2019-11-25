#!/bin/bash

if [[ -z $HOST ]]; then
  echo "Need HOST env var"
  exit 1
fi

folder=notify-watcher
destination=$HOST:$folder

echo "# Creating $folder folder if necessary"
if ! ssh $HOST stat $folder \> /dev/null 2\>\&1; then
  ssh $HOST "mkdir $folder"
fi

echo "# Copying files"
scp .env docker-compose.yml docker-compose.prod.yml $destination

echo "# Running deploy"
ssh $HOST ' \
  cd notify-watcher \
  && test -f docker-compose.other.yml || echo -e "version: \"3\"\n" > docker-compose.other.yml \
  && echo "# Pulling images" \
  && docker-compose -f docker-compose.yml -f docker-compose.prod.yml -f docker-compose.other.yml pull \
  && echo "# Mounting containers" \
  && docker-compose -f docker-compose.yml -f docker-compose.prod.yml -f docker-compose.other.yml up -d --remove-orphans \
  && echo "# Pruning system" \
  && echo y | docker system prune \
  '
