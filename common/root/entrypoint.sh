if [[ "$APP_ENV" == "prod" ]] ; then
    sed -i -e "s/display_errors =.*/display_errors = Off/g" /usr/local/etc/php/php.ini
    sed -i -e "s/display_startup_errors =.*/display_startup_errors = Off/g" /usr/local/etc/php/php.ini
    sed -i -e "s/apc.enabled =.*/apc.enabled = 1/g" /usr/local/etc/php/conf.d/apcu.ini
else
    sed -i -e "s/xdebug.remote_enable =.*/xdebug.remote_enable = 1/g" /usr/local/etc/php/conf.d/xdebug.ini
    sed -i -e "s/xdebug.remote_autostart =.*/xdebug.remote_autostart = 1/g" /usr/local/etc/php/conf.d/xdebug.ini
fi

# Tweak nginx to match the workers to cpu's
procs=$(cat /proc/cpuinfo | grep processor | wc -l)
sed -i -e "s/worker_processes .*/worker_processes $procs;/" /etc/nginx/nginx.conf

# Warm cache for Symfony
if [ -f "/app/bin/console" ]; then /app/bin/console cache:warm fi

# Start supervisord and services
/usr/bin/supervisord -n -c /etc/supervisord.conf
