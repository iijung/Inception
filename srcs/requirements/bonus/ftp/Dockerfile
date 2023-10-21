FROM alpine:3.17.5

# Installation
RUN apk update && \
    apk upgrade && \
    apk add --no-cache vsftpd && \
    rm -rf /var/cache/apk/*

# Configuration
COPY --chmod=644 conf/vsftpd.conf /etc/vsftpd/vsftpd.conf

# Start
WORKDIR /var/www
ENTRYPOINT ["vsftpd"]

EXPOSE 20-21
VOLUME ["/var/www"]
STOPSIGNAL SIGQUIT
HEALTHCHECK --interval=10s --start-period=3m --timeout=3s CMD nc -zv localhost || exit 1
