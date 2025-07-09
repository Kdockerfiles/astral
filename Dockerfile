FROM composer:2.2.23 AS c

RUN git clone https://github.com/astralapp/astral.git
WORKDIR astral
RUN git checkout d8f2404
RUN sed -i 's/Cache::put($key, $fetched, $expiry);/Cache::forever($key, $fetched);/g' app/Http/Controllers/GitHubStarsController.php
RUN sed -i 's/Cache::put($key, $new, $expiry);/Cache::forever($key, $new);/g' app/Http/Controllers/GitHubStarsController.php
RUN composer install

FROM node:18.20-alpine3.21 AS a

COPY --from=c /app/astral/ /astral/

WORKDIR /astral
RUN npm install --legacy-peer-deps
RUN npm run prod
RUN rm -rf node_modules/

FROM php:8.3-fpm-alpine3.21

COPY --from=a --chown=www-data:www-data /astral/ ./

ENV DB_CONNECTION=sqlite
ENV DB_DATABASE=/var/www/html/storage/astral.sqlite
RUN touch storage/astral.sqlite && chown www-data:www-data storage/astral.sqlite
RUN php artisan migrate --force

VOLUME /var/www/html/public
VOLUME /var/www/html/storage

COPY astral-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["astral-entrypoint.sh"]
