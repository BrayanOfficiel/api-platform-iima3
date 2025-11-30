# API Platform Symfony / Docker

## 1. Prérequis

- Docker
- Docker Compose


## 2. Lancer le projet

### Cloner le dépôt
```bash
git clone
cd api-platform-iim-a3
```

### 2.1. En local
```bash
composer install
```
Créez un fichier `.env.local` à la racine du projet et ajoutez-y la variable de connexion à la base de données PostgreSQL (à adapter selon votre configuration) :
```DATABASE_URL="postgresql://username:password@localhost:5432/database_name?serverVersion=xx&charset=utf8"```

Générez les clés Lexik :
```bash
php bin/console lexik:jwt:generate-keypair --overwrite
```

Ensuite, exécutez les migrations :
```bash
php bin/console doctrine:migrations:migrate --no-interaction
```

Lancez le serveur de développement Symfony :
```bash
symfony server:start
```

### 2.2. Avec Docker
Depuis la racine du projet :

```bash
# 1) Construire les images
docker-compose build

# 2) Démarrer les conteneurs (php, nginx, database)
docker-compose up -d
```

Une fois que les conteneurs tournent :

```bash
docker-compose exec php php bin/console doctrine:migrations:migrate --no-interaction
```

## 3. Script d’installation automatique

2 scripts sont disponibles dans `scripts/`.

Depuis le terminal, à la racine du projet :

sur Windows :
```powershell
./scripts/setup.ps1
```
ou sous Linux/MacOS :
```bash
./scripts/setup.sh
```

Ces scripts construisent les images, démarrent les conteneurs, exécutent les migrations et ouvrent l’interface API Platform.

## 4. Accès à l’application

- API : http://localhost:8080
- API Platform : http://localhost:8080/api

## 5. Structure Docker

### 5.1. Dockerfile (service PHP)

- Image de base : `php:8.3-fpm-alpine`
- Extensions installées : `intl`, `pdo_pgsql`, `opcache`, etc.
- Installation de Composer
- Copie du code dans `/var/www/html`
- Création d’un `.env` minimal pour permettre l’exécution des commandes Symfony pendant le build :
  - `APP_ENV=prod`
  - `DATABASE_URL=postgresql://dummy:dummy@dummy:5432/dummy?serverVersion=16&charset=utf8`
  - `DEFAULT_URI=http://localhost`
- Installation des dépendances avec `composer install --no-dev`

### 5.2. docker-compose

Le fichier `compose.yaml` définit :

- `php` : conteneur PHP-FPM basé sur le `Dockerfile`
- `nginx` : serveur web, exposé sur le port `8080`
- `database` : PostgreSQL 16, avec volume de données

Les variables de connexion à la base sont passées via `DATABASE_URL` dans le service `php`.
