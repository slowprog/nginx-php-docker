## Nginx PHP-FPM Docker

This is a Dockerfile/image to build a container for nginx and php-fpm.

### Versioning

| Docker Tag | Alpine Version | Nginx Version | PHP Version | Redis (ext) | PostgreSQL (ext) | MariaDB (ext) |
|-----|-------|-----|--------|--------|--------|--------|
| 7.2-psql-redis3 | 3.9 | 1.16.0 | 7.2 | 3.1.6 | + | – |
| 7.1-maria-redis2 | 3.9 | 1.16.0 | 7.1 | 2.2.8 | – | + |
| 5.6-maria-redis2 | 3.9 | 1.16.0 | 5.6 | 2.2.8 | – | + |

### Quick Start

To simply run the container:

```
docker run -d \
    --name app \
    -e 'ENV_PATH=.env.dist' \
    -v $(pwd):/app \
    -p 8080:80 \
    slowprog/nginx-php-fpm:7.2-psql-redis3
```

You can then browse to http://<DOCKER_HOST>:8080 to view the default install files. To find your DOCKER_HOST use the docker inspect to get the IP address (normally 172.17.0.2)

* *ENV_PATH* – the path to the file with environment variables to forward them to the nginx.