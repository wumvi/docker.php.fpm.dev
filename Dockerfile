FROM wumvi/php.base:7.3.6

RUN apk add --no-cache --virtual .build-deps alpine-sdk autoconf \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && apk del .build-deps