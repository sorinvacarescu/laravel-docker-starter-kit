.PHONY: install create-project build build-no-cache up stop kill_all down down-v restart destroy remake ps web app tinker dump test migrate fresh seed rollback-test optimize optimize-clear cache cache-clear db sql redis ide-helper pint pint-test enable-xdebug disable-xdebug

CONTAINER_APP = app
CONTAINER_WEB = web_server
CONTAINER_DB = db
CONTAINER_REDIS = redis

install:
	@make build
	@make up
	docker compose exec $(CONTAINER_APP) composer install
	docker compose exec $(CONTAINER_APP) cp .env.example .env
	docker compose exec $(CONTAINER_APP) php artisan key:generate
	docker compose exec $(CONTAINER_APP) php artisan storage:link
	docker compose exec $(CONTAINER_APP) chmod -R 777 storage bootstrap/cache
	#@make fresh

create-project:
	@sh ./setup.sh
	@rm -f setup.sh
	@make build
	@make up
	docker compose exec $(CONTAINER_APP) composer create-project --prefer-dist laravel/laravel src
	mv $$PWD/src/* $$PWD/src/.editorconfig $$PWD/src/.env $$PWD/src/.env.example $$PWD/src/.gitattributes $$PWD/src/.gitignore $$PWD && rm -rf src
	docker compose exec $(CONTAINER_APP) php artisan storage:link
	docker compose exec $(CONTAINER_APP) chmod -R 777 storage bootstrap/cache

build:
	docker compose build

build-no-cache:
	docker compose build --no-cache

up:
	docker compose up --detach

stop:
	docker compose stop

kill_all:
	docker kill $$(docker ps -q)

down:
	docker compose down --remove-orphans

down-v:
	docker compose down --remove-orphans --volumes

restart:
	@make down
	@make up

destroy:
	docker compose down --rmi all --volumes --remove-orphans

remake:
	@make destroy
	@make install

ps:
	docker compose ps

web:
	docker compose exec $(CONTAINER_WEB) bash

app:
	docker compose exec $(CONTAINER_APP) bash

tinker:
	docker compose exec $(CONTAINER_APP) php artisan tinker

dump:
	docker compose exec $(CONTAINER_APP) php artisan dump-server

test:
	docker compose exec $(CONTAINER_APP) php artisan test

migrate:
	docker compose exec $(CONTAINER_APP) php artisan migrate

fresh:
	docker compose exec $(CONTAINER_APP) php artisan migrate:fresh --seed

seed:
	docker compose exec $(CONTAINER_APP) php artisan db:seed

rollback-test:
	docker compose exec $(CONTAINER_APP) php artisan migrate:fresh
	docker compose exec $(CONTAINER_APP) php artisan migrate:refresh

optimize:
	docker compose exec $(CONTAINER_APP) php artisan optimize

optimize-clear:
	docker compose exec $(CONTAINER_APP) php artisan optimize:clear

cache:
	docker compose exec $(CONTAINER_APP) composer dump-autoload --optimize
	@make optimize
	docker compose exec $(CONTAINER_APP) php artisan event:cache
	docker compose exec $(CONTAINER_APP) php artisan view:cache

cache-clear:
	docker compose exec $(CONTAINER_APP) composer clear-cache
	@make optimize-clear
	docker compose exec $(CONTAINER_APP) php artisan event:clear
	docker compose exec $(CONTAINER_APP) php artisan view:clear

db:
	docker compose exec $(CONTAINER_DB) bash

sql:
	docker compose exec $(CONTAINER_DB) bash -c 'mysql -u root -p$$MYSQL_ROOT_PASSWORD $$MYSQL_DATABASE'

redis:
	docker compose exec $(CONTAINER_REDIS) redis-cli

ide-helper:
	docker compose exec $(CONTAINER_APP) php artisan clear-compiled
	docker compose exec $(CONTAINER_APP) php artisan ide-helper:generate
	docker compose exec $(CONTAINER_APP) php artisan ide-helper:meta
	docker compose exec $(CONTAINER_APP) php artisan ide-helper:models --write --reset

pint:
	docker compose exec $(CONTAINER_APP) ./vendor/bin/pint --verbose

pint-test:
	docker compose exec $(CONTAINER_APP) ./vendor/bin/pint --verbose --test

enable-xdebug:
	docker compose exec -u 0 $(CONTAINER_APP) bash -c '[ -f /usr/local/etc/php/disabled/docker-php-ext-xdebug.ini ] && cd /usr/local/etc/php/ && mv disabled/docker-php-ext-xdebug.ini conf.d/ || echo "Xdebug already enabled"'
	docker compose restart $(CONTAINER_APP)
	docker compose exec -u 0 $(CONTAINER_APP) bash -c '$$(php -m | grep -q Xdebug) && echo "Status: Xdebug ENABLED" || echo "Status: Xdebug DISABLED"'

disable-xdebug:
	docker compose exec -u 0 $(CONTAINER_APP) bash -c '[ -f /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini ] && cd /usr/local/etc/php/ && mkdir -p disabled/ && mv conf.d/docker-php-ext-xdebug.ini disabled/ || echo "Xdebug already disabled"'
	docker compose restart $(CONTAINER_APP)
	docker compose exec -u 0 $(CONTAINER_APP) bash -c '$$(php -m | grep -q Xdebug) && echo "Status: Xdebug ENABLED" || echo "Status: Xdebug DISABLED"'
