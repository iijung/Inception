FROM alpine:3.17.5

ARG FTP_USER

# Installation
RUN apk update && \
    apk upgrade && \
    apk add --no-cache vsftpd && \
    rm -rf /var/cache/apk/*

# Configuration
COPY --chmod=644 conf/vsftpd.conf /etc/vsftpd/vsftpd.conf
COPY --chmod=755 tools/docker-entrypoint.sh /

# Start
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["vsftpd", "/etc/vsftpd/vsftpd.conf"]

EXPOSE 21 21100-21110
VOLUME ["/home/$FTP_USER"]
STOPSIGNAL SIGQUIT
HEALTHCHECK --interval=10s --start-period=3m --timeout=3s CMD nc -zv localhost 21 || exit 1
