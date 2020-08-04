FROM php:7.4-fpm-alpine

# Адрес файла с переменными окружения от корня проекта.
ENV ENV_PATH=.env
ENV PHP_REDIS_VERSION=3.1.6

RUN apk update \
    && apk --no-cache --progress add \
        nginx \
        libressl \
        pcre \
        supervisor \
        sed \
        re2c \
        m4 \
        ca-certificates \
        py-pip \
    && mkdir -p /run/nginx/ \
    && chmod ugo+w /run/nginx/ \
    && rm -f /etc/nginx/nginx.conf \
    && mkdir -p /etc/nginx/conf.d \
    && mkdir -p /srv/app/ \
    && chmod -R 775 /srv/app/ \
    && chown -R nginx:nginx /var/www/ \
    && pip install --upgrade pip \
    && pip install supervisor-stdout \
    \
    # Bring in gettext so we can get `envsubst`, then throw
    # the rest away. To do this, we need to install `gettext`
    # then move `envsubst` out of the way so `gettext` can
    # be deleted completely, then move `envsubst` back.
    && apk add --no-cache --virtual .gettext gettext \
    && mv /usr/bin/envsubst /tmp/ \
    \
    && runDeps="$( \
    scanelf --needed --nobanner /usr/sbin/nginx /usr/lib/nginx/modules/*.so /tmp/envsubst \
      | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
      | sort -u \
      | xargs -r apk info --installed \
      | sort -u \
    )" \
    && apk add --no-cache --virtual .nginx-rundeps $runDeps \
    && apk del .gettext \
    && mv /tmp/envsubst /usr/local/bin/

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
    && docker-php-ext-configure zip opcache --enable-opcache \
    && docker-php-ext-install \
        intl \
        bcmath \
        pcntl \
        zip \
        pdo_pgsql \
        opcache \
    && yes | pecl install \
        igbinary \
        redis-$PHP_REDIS_VERSION \
        xdebug \
    && docker-php-ext-enable \
        igbinary \
        redis \
    && apk del .build-deps

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

WORKDIR /app

COPY ./common/root/ /
COPY ./env/root/ /
COPY ./7.4-web/rootfs /

RUN chmod 755 /entrypoint.sh \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer

EXPOSE 443 80

CMD ["/bin/sh", "/entrypoint.sh"]
