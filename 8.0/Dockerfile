# Copyright 2021 Litson & Associates Risk Management Services (Pty) Ltd.
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

# syntax=docker/dockerfile:1.3
FROM phpdockerio/php80-fpm:latest

# Fix debconf warnings upon build
ARG DEBIAN_FRONTEND=noninteractive

# host.docker.internal only for Window and Mac.
# Host IP for Linux.
ENV XDEBUG_CLIENT_HOST host.docker.internal
ENV XDEBUG_MODE debug,coverage

# Start as root
USER root

# Install required software
RUN apt-get update \
    && apt-get -y --no-install-recommends install \
            php8.0-mysql \
            php8.0-redis \
            php8.0-sqlite3 \
            php8.0-xdebug \
            php8.0-bcmath \
            php8.0-gd \
            php8.0-gmp  \
            php8.0-imagick  \
            php8.0-soap  \
            php8.0-tidy  \
            php8.0-yaml  \
    		php8.0-swoole \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* \
    && echo "pm.max_children = 10" >> /etc/php/8.0/fpm/pool.d/z-overrides.conf

COPY ../php-ini-overrides.ini /etc/php/8.0/fpm/conf.d/99-overrides.ini

# Set www-data user id and group id to pervent permissions errors
RUN groupmod -g ${GROUP_ID:-1000} -o www-data \
    && usermod -u ${USER_ID:-1000} -g ${GROUP_ID:-1000} -o www-data
