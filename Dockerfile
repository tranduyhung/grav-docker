FROM alpine:latest

RUN apk --no-cache add bash curl nginx php8 php8-fpm php8-opcache

# Fixes "crontab: must be suid to work properly"
RUN apk --no-cache add busybox-suid 

# Grav's requirements
RUN apk --no-cache add php8-ctype \
    php8-dom \
    php8-gd \
    php8-json \
    php8-mbstring \
    php8-openssl \
    php8-session \
    php8-simplexml \
    php8-xml \
    php8-zip \
    php8-curl

# Alpine doesn't provide usermod by default.
# Let nginx have user ID 1000. Change this user ID to your Linux user's ID.
RUN echo http://dl-2.alpinelinux.org/alpine/edge/community/ >> /etc/apk/repositories
RUN apk --no-cache add shadow && usermod -u 1000 nginx

# Copy configuration files.
COPY server/etc/nginx /etc/nginx
COPY server/etc/php /etc/php8

RUN mkdir /var/run/php

# Define Grav specific version of Grav or use latest stable
ARG GRAV_VERSION=latest

# Install grav.
# For Grav with Admin plugin, use https://getgrav.org/download/core/grav-admin/${GRAV_VERSION}
# and /usr/share/nginx/grav-admin.
WORKDIR /usr/share/nginx/
RUN curl -o grav.zip -SL https://getgrav.org/download/core/grav/${GRAV_VERSION} && \
    unzip grav.zip && \
    mv -T /usr/share/nginx/grav /usr/share/nginx/html/ && \
    rm grav.zip

RUN chown -R nginx:nginx /usr/share/nginx/html

# Create cron job for Grav maintenance scripts.
RUN (crontab -l; echo "* * * * * cd /usr/share/nginx/html;/usr/local/bin/php bin/grav scheduler 1>> /dev/null 2>&1") | crontab -

EXPOSE 80

WORKDIR /usr/share/nginx/html/user

VOLUME ["/usr/share/nginx/html/user"]

CMD ["/bin/bash", "-c", "php-fpm8 && chown -R nginx:nginx /var/run/php/php8-fpm.sock && crond && nginx -g 'daemon off;'"]