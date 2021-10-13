FROM php:7.3.28-fpm-alpine3.13
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \
    apk update && \
    apk add --no-cache \
    autoconf \
    build-base \
    libevent-dev \
    rabbitmq-c-dev \
    openssl-dev && \
    docker-php-ext-install sockets pcntl pdo_mysql bcmath && \
    pecl install redis && \
    pecl install amqp && \
    pecl install mongodb && \
    pecl install swoole && \
    docker-php-ext-enable redis amqp mongodb swoole opcache && \
    pecl install event
COPY ./event.ini /usr/local/etc/php/conf.d/

RUN apk add --no-cache \
    libuuid \
    e2fsprogs-dev && \
    pecl install uuid && \
    docker-php-ext-enable uuid

RUN curl -sS https://getcomposer.org/installer | php && \
	mv ./composer.phar /usr/bin/composer && \
	composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/

EXPOSE 5454 6464 9000
VOLUME /var/www
WORKDIR /var/www
