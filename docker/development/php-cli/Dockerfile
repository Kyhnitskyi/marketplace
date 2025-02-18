FROM php:8.4-cli-alpine

# Створюємо групу з ID 1000
RUN groupadd -g 1000 appuser

# Створюємо користувача з ID 1000 та додаємо його до групи
RUN useradd -u 1000 -g appuser -m appuser

RUN apk update && apk add unzip && \
    apk add postgresql-dev && \
    docker-php-ext-install pdo_pgsql pgsql

#/usr/local/etc/php = $PHP_INI_DIR
RUN mv $PHP_INI_DIR/php.ini-development $PHP_INI_DIR/php.ini

COPY ./docker/common/php/conf.d /usr/local/etc/php/conf.d

ENV COMPOSER_ALLOW_SUPERUSER 1

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/bin --filename=composer --version=2.8.3 --quiet \
    && rm -rf /root/.composer/cache

RUN chown -R appuser:appuser /var/www/html

# Перемикаємося на нового користувача
USER appuser

WORKDIR /app

