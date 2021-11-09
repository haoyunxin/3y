FROM php:7.4.25-fpm-alpine
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
RUN apk add zip libzip-dev libpng-dev autoconf build-base libevent-dev gcc libc-dev libjpeg-turbo-dev jpeg-dev freetype-dev make g++ rabbitmq-c-dev libsodium-dev libmcrypt-dev gmp-dev libmemcached-dev ca-certificates openssl-dev --no-cache
RUN apk update && apk add tzdata && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo "Asia/Shanghai" > /etc/timezone
RUN update-ca-certificates
RUN apk del tzdata
RUN docker-php-ext-configure gd --with-jpeg-dir=/usr/lib --with-freetype-dir=/usr/include/freetype2
RUN docker-php-ext-install gd sockets pcntl pdo_mysql mysqli gmp zip bcmath
RUN pecl install redis && \
    pecl install amqp && \
    pecl install mongodb && \
    pecl install swoole && \
    pecl install xdebug && \
    docker-php-ext-enable redis amqp mongodb swoole xdebug opcache && \
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
