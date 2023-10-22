# **************************************************************************** #
# build 
# **************************************************************************** #
FROM alpine:3.17.5 as build

# Installation
RUN apk update && \
    apk upgrade && \
    apk add --no-cache doxygen graphviz ttf-dejavu && \
    rm -rf /var/cache/apk/*

# Configuration
COPY --chmod=644 conf/Doxyfile /Doxyfile
ADD --chmod=644 https://github.com/iijung/CPP-Module/archive/refs/heads/main.zip .

# Build
RUN unzip main.zip && \
    doxygen /Doxyfile

# **************************************************************************** #
# main
# **************************************************************************** #
FROM alpine:3.17.5

# Installation
RUN apk update && \
    apk upgrade && \
    apk add --no-cache lighttpd && \
    rm -rf /var/cache/apk/*

# Configuration
COPY --chmod=644 conf/lighttpd.conf /etc/lighttpd/lighttpd.conf
COPY --from=build /var/www/html /var/www/localhost/htdocs

# Start
ENTRYPOINT ["lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]

EXPOSE 80
STOPSIGNAL SIGQUIT
#HEALTHCHECK --interval=10s --timeout=3s CMD curl -f http://localhost:80 || exit 1
