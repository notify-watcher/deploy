if [[ -z $HOST ]]; then
  echo "Need HOST env var"
  exit 1
fi

folder=notify-watcher
destination=$HOST:$folder

if [[ "$1" != 'f' ]]; then
  echo "# Creating $folder folder if necessary"
  if ! ssh $HOST stat $folder/acme.json \> /dev/null 2\>\&1; then
    ssh $HOST "mkdir $folder"
  fi

  echo "# Creating acme.json if necessary"
  if ! ssh $HOST stat $folder/acme.json \> /dev/null 2\>\&1; then
    echo "# Creating acme.json"
    ssh $HOST "mkdir $destination/acme.json"
  fi
fi

echo "# Copying files"
scp .env $destination
scp docker-compose.yml $destination

echo "# Running deploy"
ssh $HOST \
  'cd notify-watcher \
  && echo "# Pulling images" \
  && docker-compose pull \
  && echo "# Mounting containers" \
  && docker-compose up -d --remove-orphans \
  && echo "# Pruning system" \
  && echo y | docker system prune'
