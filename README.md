# 🐋 Docker Image for Laravel Development

> ⚠️ **Note** This is a development container image and is not suited for production!

---

This docker image uses the php-fpm base image from https://github.com/phpdocker-io and comes with required extensions for Laravel
as well as OPCache and Xdebug. It works well with a separated container running a web server such as Nginx.

## 💻 Usage

The application directory should be bound as a volume to the `/application` directory inside the container.

### Docker Compose Example With Nginx

This assumes your docker-compose file is in the root directory of your application.

```yaml
# docker-compose.yml

version: "3.8"

services:

  app:
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
    server_name local
    client_max_body_size 72M;

    access_log /var/log/nginx/application.access.log;

    root /application/public;
    index index.php;

    location / {
      try_files $uri /index.php$is_args$args;
    }

    if (!-e $request_filename) {
        rewrite ^.*$ /index.php last;
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
}
```

## ❌ Xdebug

By default, the `xdebug.client_host` is set to `host.docker.internal`, while this is fine for Mac and Windows, Linux
requires that you set it to the host IP. You can set this value to something else by using the
`XDEBUG_CLIENT_HOST` environment variable when running the container.

> To see all configuration values that are set in the image, refer to the  [php-ini-overrides.ini](./php-ini-overrides.ini) file.

## 📦 Installed extensions

- ca-certificates
- curl
- php7.4-apcu
- php7.4-apcu-bc
- php7.4-bcmath
- php7.4-cli
- php7.4-curl
- php7.4-gd
- php7.4-gmp
- php7.4-imagick
- php7.4-json
- php7.4-mbstring
- php7.4-mysql
- php7.4-opcache
- php7.4-readline
- php7.4-redis
- php7.4-soap
- php7.4-sqlite3
- php7.4-tidy
- php7.4-xdebug
- php7.4-xml
- php7.4-yaml
- php7.4-zip
- unzip
