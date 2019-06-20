FROM wumvi/php.base:latest

RUN apk add --no-cache --virtual .build-deps alpine-sdk autoconf \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && apk del .build-deps
