#!/usr/bin/env sh
set -e

if [ ! -f ".env" ]; then
    php artisan astral:install -n
fi

docker-php-entrypoint php-fpm
