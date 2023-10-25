# syntax=docker/dockerfile:1.3
FROM alpine:3.17.5

# Installation
RUN apk update && \
    apk upgrade && \
    apk add --no-cache curl php81 php81-curl php81-phar php81-fpm php81-mysqli php81-mbstring php81-tokenizer mariadb-client fcgi && \
    adduser -u 1000 -D -h /var/www www && \
    chown -R www:www /var/www && \
    rm -rf /var/cache/apk/*

# Configuration
ADD --chmod=755 https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar /usr/local/bin/wp
COPY --chmod=644 conf/www.conf /etc/php81/php-fpm.d/www.conf
COPY --chmod=755 tools/docker-entrypoint.sh /

# Start
WORKDIR /var/www
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 9000
VOLUME ["/var/www"]
STOPSIGNAL SIGQUIT
HEALTHCHECK --interval=30s --timeout=3s CMD cgi-fcgi -bind -connect localhost:9000 || exit 1
