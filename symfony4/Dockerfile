FROM whatwedo/symfony4:v2.0

RUN apk update \
    && apk add --no-cache --update php-xdebug@php

COPY ./docker/app/rootfs /

RUN sed -i "s/date\.timezone.*/date.timezone = UTC/g" /etc/php$PHP_MAJOR_VERSION/php.ini