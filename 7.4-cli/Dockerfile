FROM php:7.4-cli-alpine

# Адрес файла с переменными окружения от корня проекта.
ENV ENV_PATH=.env
ENV PHP_REDIS_VERSION=3.1.6

RUN apk add --no-cache --virtual .persistent-deps \
    git \
    icu-libs \
    libzip-dev \
    postgresql-dev

RUN set -xe \
    && apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        icu-dev \
        zlib-dev \
        zip \
    && docker-php-ext-install \
        intl \
        bcmath \
        pcntl \
        zip \
        pdo_pgsql \
        opcache \
    && docker-php-ext-configure zip \
    && docker-php-ext-configure opcache --enable-opcache \
    && yes | pecl install \
        igbinary \
        redis-$PHP_REDIS_VERSION \
        xdebug \
    && docker-php-ext-enable \
        igbinary \
        redis \
    && apk del .build-deps

WORKDIR /app

COPY ./common/root/ /
COPY ./env/root/ /
COPY ./7.4-cli/rootfs /

RUN sed -E -i -e 's/display_errors = On/display_errors = Off/' /usr/local/etc/php/php.ini \
    && sed -E -i -e 's/display_startup_errors = On/display_startup_errors = Off/' /usr/local/etc/php/php.ini \
    && sed -E -i -e 's/;opcache.preload=/opcache.preload=\/app\/var\/cache\/prod\/srcApp_KernelProdContainer.preload.php/' /usr/local/etc/php/php.ini \
    && sed -E -i -e 's/;opcache.preload_user=/opcache.preload_user=nginx/' /usr/local/etc/php/php.ini \
    && sed -E -i -e 's/;opcache.memory_consumption=128/opcache.memory_consumption=256/' /usr/local/etc/php/php.ini \
    && sed -E -i -e 's/;opcache.max_accelerated_files=10000/opcache.max_accelerated_files=20000/' /usr/local/etc/php/php.ini \
    && sed -E -i -e 's/;opcache.validate_timestamps=1/opcache.validate_timestamps=0/' /usr/local/etc/php/php.ini \
    && sed -E -i -e 's/;opcache.max_wasted_percentage=5/opcache.max_wasted_percentage=10/' /usr/local/etc/php/php.ini \
    && sed -E -i -e 's/;realpath_cache_size = 4096k/realpath_cache_size=4096k/' /usr/local/etc/php/php.ini \
    && sed -E -i -e 's/;realpath_cache_ttl = 120/realpath_cache_ttl=600/' /usr/local/etc/php/php.ini

RUN rm /usr/local/etc/php/conf.d/xdebug.ini \
    && rm /entrypoint.sh \
    && rm /run_nginx.sh \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer
