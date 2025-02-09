FROM php:8.4-cli-alpine as builder

RUN apk add unzip

ENV COMPOSER_ALLOW_SUPERUSER 1

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/bin --filename=composer --version=1.10.26 --quiet \
    && rm -rf /root/.composer/cache

WORKDIR /app

COPY ./composer.json ./composer.lock ./

RUN composer install --no-dev --prefer-dist --no-progress --no-suggest --optimize-autoloader \
    && rm -rf /root/.composer/cache


FROM php:8.4-cli-alpine

# Встановлюємо пакети для PostgreSQL
RUN apk add --no-cache postgresql-dev && \
    docker-php-ext-install pdo_pgsql pgsql

#/usr/local/etc/php = $PHP_INI_DIR
RUN mv $PHP_INI_DIR/php.ini-production $PHP_INI_DIR/php.ini

COPY ./docker/common/php/conf.d /usr/local/etc/php/conf.d

WORKDIR /app

COPY --from=builder /app ./
COPY ./ ./

