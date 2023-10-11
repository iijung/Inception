# syntax=docker/dockerfile:1.3
FROM alpine:3.17.5

# Mount Bind Volume
VOLUME ["/var/www"]

# Install Wordpress php
RUN apk update && \
    apk upgrade && \
    apk add --no-cache curl php81 php81-curl php81-phar php81-fpm php81-mysqli php81-mbstring mariadb-client && \
    rm -rf /var/cache/apk/*

# Expose port 9000
EXPOSE 9000

# Configure
COPY --chmod=644 conf/www.conf /etc/php81/php-fpm.d/www.conf
ADD --chmod=755 https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar /usr/local/bin/wp
RUN wp core download --path=/var/www --locale=ko_KR --version=6.3.1

STOPSIGNAL SIGQUIT

# Start the php
WORKDIR /var/www
COPY --chmod=755 tools/docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
