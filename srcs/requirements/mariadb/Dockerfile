FROM alpine:3.17.5

# Installation
RUN apk update && \
    apk upgrade && \
    apk add --no-cache mariadb mariadb-client && \
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql && \
    rm -rf /var/cache/apk/*

# Configuration
COPY --chmod=644 conf/my.cnf /etc/my.cnf
COPY --chmod=644 conf/mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf
COPY --chmod=755 tools/docker-entrypoint.sh /

# Start
WORKDIR /var/lib/mysql
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["mariadbd-safe"]

EXPOSE 3306
VOLUME ["/var/lib/mysql"]
STOPSIGNAL SIGQUIT
HEALTHCHECK --interval=10s --start-period=3m --timeout=3s CMD mariadb-admin ping -h localhost -u root || exit 1
