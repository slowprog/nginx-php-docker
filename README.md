## Nginx PHP-FPM Docker

This is a Dockerfile/image to build a container for PHP projects (nginx, php-fpm, cli). Base on Alpine 3.9.

### Versioning

| Docker Tag | Nginx | PHP Version | Redis (ext) | PostgreSQL (ext) | MariaDB (ext) | MongoDB (ext) | OPCache (ext) |
|-----|-------|--------|--------|--------|--------|--------|
| 7.4-web | + | 7.4 | 3.1.6 | + | – | – | + |
| 7.3-web-maria | + | 7.3 | 3.1.6 | – | + | – | – |
| 7.3-web | + | 7.3 | 3.1.6 | + | – | – | – |
| 7.2-web | + | 7.2 | 3.1.6 | + | – | – | – |
| 7.4-cli | – | 7.4 | 3.1.6 | + | – | – | + |
| 7.3-cli | – | 7.3 | 3.1.6 | + | – | – | – |
| 7.2-cli | – | 7.2 | 3.1.6 | + | – | – | – |
| 7.3-web-maria | + | 7.3| 3.1.6 | – | + | – | – |
| 7.1-web-maria | + | 7.1 | 3.1.6 | – | + | – | – |
| 7.0-web-maria | + | 7.0 | 3.1.6 | – | + | – | – |
| 5.6-web-maria | + | 5.6 | 3.1.6 | – | + | + | – |
| symfony4 | + | 7.3 | 3.1.6 | – | - | - | – |

### Quick Start

To simply run the container:

```
docker run -d \
    --name app \
    -e 'ENV_PATH=.env.dist' \
    -v $(pwd):/app \
    -p 8080:80 \
    slowprog/nginx-php-fpm:7.2-web
```

You can then browse to http://<DOCKER_HOST>:8080 to view the default install files. To find your DOCKER_HOST use the docker inspect to get the IP address (normally 172.17.0.2)

* *ENV_PATH* – the path to the file with environment variables to forward them to the nginx.
