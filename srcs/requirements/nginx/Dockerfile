# syntax=docker/dockerfile:1.3
FROM alpine:3.17.5

# Install
RUN apk update && \
    apk upgrade && \
    apk add --no-cache openssl nginx curl && \
    adduser -u 1000 -D -h /var/www www && \
    chown -R www:www /var/www && \
    rm -rf /var/cache/apk/*

# Configuration
COPY --chmod=644 conf/nginx.conf /etc/nginx/nginx.conf

# Start
ENTRYPOINT ["nginx", "-g", "daemon off;"]

EXPOSE 443
VOLUME ["/var/www"]
STOPSIGNAL SIGQUIT
HEALTHCHECK --interval=10s --timeout=3s CMD curl -k https://localhost:443 || exit 1
