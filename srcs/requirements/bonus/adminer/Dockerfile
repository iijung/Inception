FROM alpine:3.17.5

# Installation
RUN apk update && \
    apk upgrade && \
    apk add --no-cache php php-session php-pdo php-pdo_mysql php-mysqli && \
    rm -rf /var/cache/apk/*

# Configuration
WORKDIR /var/www/html
ADD --chmod=644 https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php index.php

# Start
ENTRYPOINT ["php", "-S", "0.0.0.0:8080", "-t", "/var/www/html"]

EXPOSE 8080
STOPSIGNAL SIGINT
HEALTHCHECK --interval=10s --timeout=3s CMD nc -zv localhost 8080 | exit 1
