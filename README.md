# 🐋 Docker Image for Laravel Development

[![Build & Publish](https://github.com/LitsonRMS/php-dev-image/actions/workflows/build-publish.yml/badge.svg)](https://github.com/LitsonRMS/php-dev-image/actions/workflows/build-publish.yml)

---

> ⚠️ **Note** This is a development container image and is not suited for production!

This docker image uses the php-fpm base image from [phpdocker-io](https://github.com/phpdocker-io) and comes with required extensions for Laravel
as well as OPCache and Xdebug. It works well with a separated container running a web server such as Nginx.

## 💻 Usage

### Available Tags

> The tag matches the version of PHP installed in the image.

PHP Version|Image Available
-|-
< 7.3|Unsupported
7.3|:white_check_mark:
7.4|:white_check_mark:
8.0|Planned

### Docker Compose Example With Nginx

This assumes your docker-compose file is in the root directory of your application.

```yaml
# docker-compose.yml

version: "3.8"

services:

  app:
    image: ghcr.io/litsonrms/php-dev:7.4
    volumes:
      - .:/application

  webserver:
    image: nginx:alpine
    volumes:
      - ./public:/application/public:cached
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

    # root should point to the directory that contains the application entnrypoint
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

## ❌debug

By default, the `xdebug.client_host` is set to `host.docker.internal`, while this is fine for Mac and Windows, Linux
requires that you set it to the host IP. You can set this value to something else by using the
`XDEBUG_CLIENT_HOST` environment variable when running the container.

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
- php-json
- php-mbstring
- php-mysql
- php-opcache
- php-readline
- php-redis
- php-soap
- php-sqlite3
- php-tidy
- php-xdebug
- php-xml
- php-yaml
- php-zip
- unzip
