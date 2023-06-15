#!/usr/bin/env sh

apk --update --no-cache add \
	curl \
	php82 \
	php82-bcmath \
	php82-bz2 \
	php82-ctype \
	php82-curl \
	php82-dom \
	php82-fileinfo \
	php82-fpm \
	php82-gd \
	php82-gettext \
	php82-gmp \
	php82-iconv \
	php82-intl \
	php82-json \
	php82-mbstring \
	php82-mysqli \
	php82-mysqlnd \
	php82-odbc \
	php82-opcache \
	php82-openssl \
	php82-pdo \
	php82-pdo_dblib \
	php82-pdo_mysql \
	php82-pdo_odbc \
	php82-pdo_pgsql \
	php82-pdo_sqlite \
	php82-phar \
	php82-posix \
	php82-session \
	php82-simplexml \
	php82-soap \
	php82-sqlite3 \
	php82-tokenizer \
	php82-xdebug \
	php82-xml \
	php82-xmlreader \
	php82-xmlwriter \
	php82-zip

adduser -D -s /sbin/nologin -h /dev/null -g php-fpm php-fpm
echo "chdir = $CHDIR" >> /etc/supervisord.conf
curl -sS https://getcomposer.org/installer | \
php82 -- --install-dir=/usr/bin --filename=composer
