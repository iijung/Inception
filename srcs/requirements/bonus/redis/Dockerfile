FROM alpine:3.17.5

# Installation
RUN apk update && \
    apk upgrade && \
    apk add --no-cache redis && \
    rm -rf /var/cache/apk/*

# Configuration
COPY --chmod=644 conf/redis.conf /etc/redis.conf

# Start
ENTRYPOINT ["redis-server", "/etc/redis.conf"]

EXPOSE 6379
STOPSIGNAL SIGQUIT
HEALTHCHECK --interval=10s --start-period=3m --timeout=3s CMD redis-cli -h localhost -p 6379 PING || exit 1
