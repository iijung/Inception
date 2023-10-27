FROM alpine:3.17.5

# Installation
RUN apk update && \
    apk upgrade && \
    apk add --no-cache exim dovecot mailx && \
	chown -R mail:mail /var/mail && \
	chmod 2775 /var/mail && \
    rm -rf /var/cache/apk/*

# Configuration
COPY --chmod=644 conf/exim.conf /etc/exim/exim.conf
COPY --chmod=755 tools/docker-entrypoint.sh /

# Start
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["exim", "-bd", "-q15m"]

EXPOSE 25
STOPSIGNAL SIGQUIT
HEALTHCHECK --interval=10s --start-period=3m --timeout=3s CMD nc -zv localhost 21 || exit 1
