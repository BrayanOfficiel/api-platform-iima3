FROM php:8.3-fpm-alpine

# Dépendances système nécessaires à PHP et PostgreSQL
RUN apk add --no-cache \
    git \
    icu-data-full \
    icu-libs \
    libpq \
    libzip-dev \
    zip \
    unzip \
    postgresql-dev \
    && docker-php-ext-install -j$(nproc) \
    intl \
    pdo_pgsql \
    opcache

# Installation de Composer (gestionnaire de dépendances PHP)
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Définition du répertoire de travail de l’application
WORKDIR /var/www/html

# Copie de tout le code de l’application (bin/console inclus)
COPY . .

# Création d'un fichier .env pour les scripts Symfony pendant le build
RUN printf "APP_ENV=prod\nDATABASE_URL=postgresql://dummy:dummy@dummy:5432/dummy?serverVersion=16&charset=utf8\nDEFAULT_URI=http://localhost\n" > .env

# Installation des dépendances PHP sans dépendances de développement
RUN composer install --no-dev --optimize-autoloader --no-interaction --no-progress

# Attribution des droits au user www-data
RUN chown -R www-data:www-data /var/www/html

# Port exposé par PHP-FPM
EXPOSE 9000

# Commande de démarrage du conteneur
CMD ["php-fpm"]
