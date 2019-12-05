#!/bin/bash

function dcompose() {
  docker-compose -f docker-compose.yml -f docker-compose.dev.yml $@
}
if [[ "$1" == "p" ]]; then
  dcompose pull
fi

dcompose up -d --remove-orphans
