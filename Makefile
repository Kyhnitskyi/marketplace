init:docker-down-clear build-api docker-up api-composer-install php-migrate
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

php-migrate:
	docker-compose run --rm php-cli php artisan migrate

test:
	docker-compose run --rm php-cli php artisan test

push-dev-cache: push

build-api:
	DOCKER_BUILDKIT=1 docker build --pull --build-arg BUILDKIT_INLINE_CACHE=1 \
	--cache-from ${REGISTRY}/marketplace-nginx:cache \
	--tag ${REGISTRY}/marketplace-nginx:cache \
 	--tag ${REGISTRY}/marketplace-nginx:${IMAGE_TAG} \
	--file docker/development/nginx/Dockerfile ./

	DOCKER_BUILDKIT=1 docker build --pull --build-arg BUILDKIT_INLINE_CACHE=1 \
	--cache-from ${REGISTRY}/marketplace-api-php-fpm:cache \
	--tag ${REGISTRY}/marketplace-api-php-fpm:cache \
 	--tag ${REGISTRY}/marketplace-api-php-fpm:${IMAGE_TAG} \
	--file docker/development/php-fpm/Dockerfile ./

	DOCKER_BUILDKIT=1 docker build --pull --build-arg BUILDKIT_INLINE_CACHE=1 \
	--cache-from ${REGISTRY}/marketplace-php-cli:cache \
	--tag ${REGISTRY}/marketplace-php-cli:cache \
	--tag ${REGISTRY}/marketplace-php-cli:${IMAGE_TAG} \
	--file docker/development/php-cli/Dockerfile ./

try-build:
	REGISTRY=localhost IMAGE_TAG=0 make build-api

push:
	docker push ${REGISTRY}/marketplace-nginx:cache
	docker push ${REGISTRY}/marketplace-nginx:${IMAGE_TAG}

	docker push ${REGISTRY}/marketplace-api-php-fpm:cache
	docker push ${REGISTRY}/marketplace-api-php-fpm:${IMAGE_TAG}

	docker push ${REGISTRY}/marketplace-php-cli:cache
	docker push ${REGISTRY}/marketplace-php-cli:${IMAGE_TAG}


