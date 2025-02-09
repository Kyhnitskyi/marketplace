FROM php:8.4-fpm-alpine

# Встановлюємо пакети для PostgreSQL
RUN apk add --no-cache postgresql-dev && \
    docker-php-ext-install pdo_pgsql pgsql

#/usr/local/etc/php = $PHP_INI_DIR
RUN mv $PHP_INI_DIR/php.ini-development $PHP_INI_DIR/php.ini

COPY ./common/php/conf.d /usr/local/etc/php/conf.d

WORKDIR /app
