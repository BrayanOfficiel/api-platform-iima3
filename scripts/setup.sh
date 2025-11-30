#!/usr/bin/env sh
set -e

docker-compose build
docker-compose up -d
docker-compose exec php php bin/console doctrine:migrations:migrate --no-interaction
xdg-open "http://localhost:8080/api" 2>/dev/null || open "http://localhost:8080/api" 2>/dev/null || true
