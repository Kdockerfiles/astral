FROM composer:1.10.19 as c

RUN git clone https://github.com/astralapp/astral.git
WORKDIR astral
RUN git checkout 38d98ef
RUN sed -i 's/Cache::put($key, $fetched, $expiry);/Cache::forever($key, $fetched);/g' app/Http/Controllers/GitHubStarsController.php
RUN sed -i 's/Cache::put($key, $new, $expiry);/Cache::forever($key, $new);/g' app/Http/Controllers/GitHubStarsController.php
RUN composer install

FROM node:14.17-alpine3.14 as a

COPY --from=c /app/astral/ /astral/

WORKDIR /astral
RUN yarn
RUN yarn prod
RUN rm -rf node_modules/

FROM php:7.4-fpm-alpine3.14

COPY --from=a --chown=www-data:www-data /astral/ ./

ENV DB_CONNECTION=sqlite
ENV DB_DATABASE=/var/www/html/storage/astral.sqlite
RUN touch storage/astral.sqlite && chown www-data:www-data storage/astral.sqlite
RUN php artisan migrate --force

VOLUME /var/www/html/public
VOLUME /var/www/html/storage

COPY astral-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["astral-entrypoint.sh"]
