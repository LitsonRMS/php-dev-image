# syntax=docker/dockerfile:1.2
FROM phpdockerio/php74-fpm:latest
WORKDIR "/application"

# Fix debconf warnings upon build
ARG DEBIAN_FRONTEND=noninteractive

# host.docker.internal only for Window and Mac.
# Host IP for Linux.
ENV XDEBUG_CLIENT_HOST host.docker.internal

# Start as root
USER root

# Install required software
RUN apt-get update \
    && apt-get -y --no-install-recommends install \
            php7.4-mysql \
            php7.4-redis \
            php7.4-sqlite3 \
            php7.4-xdebug \
            php7.4-bcmath \
            php7.4-gd \
            php7.4-gmp  \
            php7.4-imagick  \
            php7.4-soap  \
            php7.4-tidy  \
            php7.4-yaml  \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* \
    && echo "pm.max_children = 10" >> /etc/php/7.4/fpm/pool.d/z-overrides.conf

COPY php-ini-overrides.ini /etc/php/7.4/fpm/conf.d/99-overrides.ini

# Set www-data user id and group id to pervent permissions errors
RUN groupmod -g ${GROUP_ID:-1000} -o www-data \
    && usermod -u ${USER_ID:-1000} -g ${GROUP_ID:-1000} -o www-data

VOLUME /application
