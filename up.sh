#!/bin/bash

docker-compose pull
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d --remove-orphans
