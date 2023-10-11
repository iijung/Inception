FROM alpine:3.17.5

# Mount Bind Volume
VOLUME ["/var/lib/mysql"]

# Install MariaDB
RUN apk update && \
    apk upgrade && \
    apk add --no-cache mariadb mariadb-client && \
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql && \
    rm -rf /var/cache/apk/*

# Expose port 3306
EXPOSE 3306

# HealthCheck
HEALTHCHECK --interval=10s --start-period=3m --timeout=3s CMD mariadb-admin ping -h localhost -u root || exit 1

# Start the MariaDB server
COPY --chmod=644 conf/my.cnf /etc/my.cnf
COPY --chmod=644 conf/mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf
COPY --chmod=755 tools/docker-entrypoint.sh .
ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["mariadbd-safe"]
