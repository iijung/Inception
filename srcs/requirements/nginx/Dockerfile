# syntax=docker/dockerfile:1.3
FROM alpine:3.17.5

# Mount Bind Volume
VOLUME ["/var/www"]

# Installation
RUN apk update && \
    apk upgrade && \
    apk add --no-cache openssl nginx && \
    adduser -D -g 'www' www && \
    mkdir /www && \
    chown -R www:www /var/lib/nginx && \
    chown -R www:www /var/www && \
    rm -rf /var/cache/apk/*

# Expose 443
EXPOSE 443

STOPSIGNAL SIGQUIT

# HealthCheck
#HEALTHCHECK --interval=10s --timeout=3s CMD curl -f http://localhost:443 || exit 1

# Start Nginx
COPY --chmod=644 conf/nginx.conf /etc/nginx/nginx.conf
ENTRYPOINT ["nginx", "-g", "daemon off;"]
