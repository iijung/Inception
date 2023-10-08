FROM alpine:3.17.5

# Mount Bind Volume
VOLUME ["/var/lib/mysql"]

# Install MariaDB
RUN apk update && \
    apk add --no-cache mariadb mariadb-client && \
	mariadb-install-db --user=mysql --datadir=/var/lib/mysql

# Expose port 3306
EXPOSE 3306

# HealthCheck
HEALTHCHECK --interval=10s --start-period=3m --timeout=3s CMD mariadb-admin ping -h localhost -u root || exit 1

# Start the MariaDB server
COPY conf/my.cnf /etc/my.cnf
COPY conf/mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf
COPY tools/docker-entrypoint.sh .
ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["mariadbd-safe"]
