<p align="center"><a href="https://laravel.com" target="_blank"><img src="https://raw.githubusercontent.com/laravel/art/master/logo-lockup/5%20SVG/2%20CMYK/1%20Full%20Color/laravel-logolockup-cmyk-red.svg" width="400" alt="Laravel Logo"></a></p>

# Laravel Docker Starter Kit
- Laravel
- PHP v8.3.x
- MySQL v8.4.x (Default)
- MariaDB v10.11.x (Option)
- PostgresSQL v16.x (Option)
- phpMyAdmin v5.x
- Mailpit v1.x
- Node.js v20.x
- NPM v10.x
- Yarn v1.x
- Vite v5.x
- Redis v7.2.x (Option)

# Requirements
- Stable version of [Docker](https://docs.docker.com/engine/install/)
- Compatible version of [Docker Compose](https://docs.docker.com/compose/install/#install-compose)

# Usage

### Init docker
- Click `Use this template` in github 

### Install Laravel (For first time only)
- `make create-project`

### Run exist project after clone (For first time only)
- `make install`

### Run project from the second time onwards
- `make up`

# Notes

### Laravel App
- URL: http://localhost

### DB
- Env
    ```
    DB_CONNECTION=mysql
    DB_HOST=db
    DB_PORT=3306
    DB_DATABASE=laravel
    DB_USERNAME=root
    DB_PASSWORD=password
    ```

### Mailpit
- URL: http://localhost:8025
- Env
    ```
    MAIL_MAILER=smtp
    MAIL_HOST=mail
    MAIL_PORT=1025
    MAIL_USERNAME=null
    MAIL_PASSWORD=null
    MAIL_ENCRYPTION=null
    MAIL_FROM_ADDRESS="hello@example.com"
    MAIL_FROM_NAME="${APP_NAME}"
    ```

### phpMyAdmin
- URL: http://localhost:8080
- Server: `db`
- Username: `root`
- Password: `password`
- Database: `laravel`

### Redis
- Env
    ```
    REDIS_CLIENT=phpredis
    REDIS_HOST=redis
    REDIS_PASSWORD=null
    REDIS_PORT=6379
    ```
