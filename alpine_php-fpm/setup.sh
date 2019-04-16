#!/usr/bin/env sh

apk --update --no-cache add \
	curl \
	php7 \
	php7-bcmath \
	php7-bz2 \
	php7-ctype \
	php7-curl \
	php7-dom \
	php7-fileinfo \
	php7-fpm \
	php7-gd \
	php7-gettext \
	php7-gmp \
	php7-iconv \
	php7-intl \
	php7-json \
	php7-mbstring \
	php7-mcrypt \
	php7-mysqli \
	php7-mysqlnd \
	php7-odbc \
	php7-opcache \
	php7-openssl \
	php7-pdo \
	php7-pdo_dblib \
	php7-pdo_mysql \
	php7-pdo_odbc \
	php7-pdo_pgsql \
	php7-pdo_sqlite \
	php7-phar \
	php7-posix \
	php7-session \
	php7-simplexml \
	php7-soap \
	php7-sqlite3 \
	php7-tokenizer \
	php7-xdebug \
	php7-xml \
	php7-xmlreader \
	php7-xmlrpc \
	php7-xmlwriter \
	php7-zip

adduser -D -s /sbin/nologin -h /dev/null -g php-fpm php-fpm
echo "chdir = $CHDIR" >> /etc/supervisord.conf
curl -sS https://getcomposer.org/installer | \
php -- --install-dir=/usr/bin --filename=composer
