#!/bin/bash

docker-compose -f docker-compose.yml -f docker-compose.dev.yml down
echo y | docker system prune
