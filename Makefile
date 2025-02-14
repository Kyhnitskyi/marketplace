init:docker-down-clear docker-pull docker-build docker-up api-composer-install php-migrate
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
	docker-compose build

api-composer-install:
	docker-compose run --rm php-cli ls -la /app
	docker-compose run --rm php-cli composer install -vvv

php-migrate:
	docker-compose run --rm php-cli php artisan migrate

test:
	docker-compose run --rm php-cli php artisan test

build-api:
	docker build --pull --file docker/production/nginx/Dockerfile --tag ${REGISTRY}/nginx:${IMAGE_TAG} ./
	docker build --pull --file docker/production/php-fpm/Dockerfile --tag ${REGISTRY}/api-php-fpm:${IMAGE_TAG} ./
	docker build --pull --file docker/production/php-cli/Dockerfile --tag ${REGISTRY}/php-cli:${IMAGE_TAG} ./

try-build:
	REGISTRY=localhost IMAGE_TAG=0 make build-api

push:
	docker push ${REGISTRY}/nginx:${IMAGE_TAG}
	docker push ${REGISTRY}/api-php-fpm:${IMAGE_TAG}
	docker push ${REGISTRY}/php-cli:${IMAGE_TAG}

