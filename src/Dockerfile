# Copyright 2022 Litson & Associates Risk Management Services (Pty) Ltd.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# syntax=docker/dockerfile:1
ARG PHP_VERSION
FROM phpdockerio/php:${PHP_VERSION}-fpm

# host.docker.internal only for Window and Mac.
# Host IP for Linux.
ENV XDEBUG_CLIENT_HOST host.docker.internal
ENV XDEBUG_MODE debug,coverage

RUN rm -f /etc/apt/apt.conf.d/docker-clean; \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache

ARG PHP_VERSION

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
 	apt update && apt-get -y --no-install-recommends install \
            php${PHP_VERSION}-mysql \
            php${PHP_VERSION}-redis \
            php${PHP_VERSION}-sqlite3 \
            php${PHP_VERSION}-xdebug \
            php${PHP_VERSION}-bcmath \
            php${PHP_VERSION}-gd \
            php${PHP_VERSION}-gmp  \
            php${PHP_VERSION}-imagick  \
            php${PHP_VERSION}-soap  \
            php${PHP_VERSION}-tidy  \
            php${PHP_VERSION}-yaml  \
    		php${PHP_VERSION}-swoole \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* \
    && echo "pm.max_children = 10" >> /etc/php/${PHP_VERSION}/fpm/pool.d/z-overrides.conf


COPY php-ini-overrides.ini /etc/php/${PHP_VERSION}/fpm/conf.d/99-overrides.ini

RUN groupmod -g ${GROUP_ID:-1000} -o www-data \
    && usermod -u ${USER_ID:-1000} -g ${GROUP_ID:-1000} -o www-data \
    && chown -R www-data:www-data /run

USER www-data
