init:docker-down-clear docker-build docker-up api-composer-install generate-key php-migrate
init-dev:docker-down-clear docker-build docker-up api-composer-install generate-key
up:docker-up
down:docker-down
restart:docker-down docker-up

docker-up:
	docker-compose up -d

docker-down:
	docker-compose down

docker-down-clear:
	docker-compose down -v --remove-orphans

docker-pull:
	docker-compose pull

docker-build:
	DOCKER_BUILDKIT=1 COMPOSE_DOCKER_CLI_BUILD=1 docker-compose build --build-arg BUILDKIT_INLINE_CACHE=1

api-composer-install:
	docker-compose run --rm php-cli composer install

generate-key:
	docker-compose run --rm php-cli php artisan key:generate

php-migrate:
	docker-compose run --rm php-cli php artisan migrate

test:
	docker-compose run --rm php-cli php artisan test

push-dev-cache: push

build-api:
	DOCKER_BUILDKIT=1 docker build --pull --build-arg BUILDKIT_INLINE_CACHE=1 \
	--cache-from ${REGISTRY}/market:cache \
	--tag ${REGISTRY}/market:cache \
	--file docker/development/nginx/Dockerfile ./

	DOCKER_BUILDKIT=1 docker build --pull --build-arg BUILDKIT_INLINE_CACHE=1 \
	--cache-from ${REGISTRY}/market:api-php-fpm-cache \
	--tag ${REGISTRY}/market:api-php-fpm-cache \
	--file docker/development/php-fpm/Dockerfile ./

	DOCKER_BUILDKIT=1 docker build --pull --build-arg BUILDKIT_INLINE_CACHE=1 \
	--cache-from ${REGISTRY}/market:php-cli-cache \
	--tag ${REGISTRY}/market:php-cli-cache \
	--file docker/development/php-cli/Dockerfile ./

tags:
	docker tag marketplace-nginx:cache ${REGISTRY}/market:nginx-cache
	docker tag marketplace-nginx:cache ${REGISTRY}/market:nginx-${IMAGE_TAG}

	docker tag marketplace-api-php-fpm:cache ${REGISTRY}/market:api-php-fpm-cache
	docker tag marketplace-api-php-fpm:cache ${REGISTRY}/market:api-php-fpm-${IMAGE_TAG}

	docker tag marketplace-php-cli:cache ${REGISTRY}/market:php-cli-cache
	docker tag marketplace-php-cli:cache ${REGISTRY}/market:php-cli-${IMAGE_TAG}

try-build:
	REGISTRY=localhost IMAGE_TAG=0 make build-api

push:
	docker push ${REGISTRY}/market:nginx-cache
	docker push ${REGISTRY}/market:nginx-${IMAGE_TAG}

	docker push ${REGISTRY}/market:api-php-fpm-cache
	docker push ${REGISTRY}/market:api-php-fpm-${IMAGE_TAG}

	docker push ${REGISTRY}/market:php-cli-cache
	docker push ${REGISTRY}/market:php-cli-${IMAGE_TAG}


