# 🐋 Docker Image for Laravel Development

[![Build & Publish](https://github.com/LitsonRMS/php-dev-image/actions/workflows/build-publish.yml/badge.svg)](https://github.com/LitsonRMS/php-dev-image/actions/workflows/build-publish.yml)

---

> ⚠️ **Note** This is a development container image and is not suited for production!

This docker image uses the php-fpm base image from [phpdocker-io](https://github.com/phpdocker-io) and comes with required extensions for Laravel
as well as OPCache and Xdebug. It works well with a separated container running a web server such as Nginx.

## 💻 Usage

### Available Tags

Daily builds are done for all versions of PHP which still receive security
updates as shown on https://www.php.net/supported-versions.php.

> **Note** The tag matches the version of PHP installed in the image.

| PHP Version | Image Available | Daily Builds |
|:-----------:|:---------------:|:------------:|
|   <= 7.2    |        ❌        |      ❌       |
|     7.3     |        ✅        |      ❌       |
|     7.4     |        ✅        |      ❌       |
|     8.0     |        ✅        |      ❌       |
|     8.1     |        ✅        |      ✅       |
|     8.2     |        ✅        |      ✅       |
|     8.3     |        ✅        |      ✅       |

### Docker Compose Example With Nginx

This configuration assumes you are using Laravel with the `docker-compose.yml` and 
`nginx.conf` files in the root directory of your application.

```yaml
# docker-compose.yml
services:

  app:
    image: ghcr.io/litsonrms/php-dev:8.2
    working_dir: /var/www
    volumes:
      - .:/var/www

  webserver:
    image: nginx:alpine
    volumes:
      - ./public:/var/www/public:cached
      - ./nginx.conf:/etc/nginx/conf.d/default.conf
    ports:
      - "8088:80"
```

```nginx
# nginx.conf

server {
    listen 80 default;
    server_name localhost;
    client_max_body_size 72M;

    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-Content-Type-Options "nosniff";

    charset utf-8;

    access_log /var/log/nginx/application.access.log;

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    error_page 404 /index.php;

    # root should point to the directory that contains the application entrypoint
    root /application/public;
    index index.php;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        fastcgi_pass app:9000; # 'app' is the name of the service in docker-compose.yml
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param PHP_VALUE "error_log=/var/log/nginx/application_php_errors.log";
        fastcgi_buffers 16 16k;
        fastcgi_buffer_size 32k;
        fastcgi_read_timeout 3600;
        include fastcgi_params;
    }

     location ~ /\.(?!well-known).* {
        deny all;
    }
}
```

## ❌debug default config

`xdebug.client_host` is set to `host.docker.internal` and can be changed using the `XDEBUG_CLIENT_HOST` environment variable.
Note: The default should be fine for Mac and Windows, if you are on Linux you should set this to the host IP.

`xdebug.mode` is set to `debug,coverage` and can be changed using the `XDEBUG_MODE` environment variable.

> To see all configuration values that are set in the image, refer to the  [php-ini-overrides.ini](./php-ini-overrides.ini) file.

## 📦 Installed extensions

- ca-certificates
- curl
- php-apcu
- php-apcu-bc
- php-bcmath
- php-cli
- php-curl
- php-gd
- php-gmp
- php-imagick
- php-intl
- php-json
- php-mbstring
- php-mysql
- php-opcache
- php-readline
- php-redis
- php-soap
- php-swoole
- php-sqlite3
- php-tidy
- php-xdebug
- php-xml
- php-yaml
- php-zip
- unzip
