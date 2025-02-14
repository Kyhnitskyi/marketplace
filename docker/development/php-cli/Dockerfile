FROM php:8.4-cli-alpine

RUN apk update && apk add unzip && \
    apk add postgresql-dev && \
    docker-php-ext-install pdo_pgsql pgsql

#/usr/local/etc/php = $PHP_INI_DIR
RUN mv $PHP_INI_DIR/php.ini-development $PHP_INI_DIR/php.ini

COPY ./common/php/conf.d /usr/local/etc/php/conf.d

ENV COMPOSER_ALLOW_SUPERUSER 1

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/bin --filename=composer --version=2.8.3 --quiet \
    && rm -rf /root/.composer/cache

WORKDIR /app

RUN echo "ls -la /app"
