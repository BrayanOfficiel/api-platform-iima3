docker-compose build
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

docker-compose up -d
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

docker-compose exec php php bin/console doctrine:migrations:migrate --no-interaction
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Start-Process "http://localhost:8080/api"
