#!/usr/bin/env sh

apk --update --no-cache add \
	curl \
	php8 \
	php8-bcmath \
	php8-bz2 \
	php8-ctype \
	php8-curl \
	php8-dom \
	php8-fileinfo \
	php8-fpm \
	php8-gd \
	php8-gettext \
	php8-gmp \
	php8-iconv \
	php8-intl \
	php8-json \
	php8-mbstring \
	php8-pecl-mcrypt \
	php8-mysqli \
	php8-mysqlnd \
	php8-odbc \
	php8-opcache \
	php8-openssl \
	php8-pdo \
	php8-pdo_dblib \
	php8-pdo_mysql \
	php8-pdo_odbc \
	php8-pdo_pgsql \
	php8-pdo_sqlite \
	php8-phar \
	php8-posix \
	php8-session \
	php8-simplexml \
	php8-soap \
	php8-sqlite3 \
	php8-tokenizer \
	php8-xdebug \
	php8-xml \
	php8-xmlreader \
	php8-xmlwriter \
	php8-zip

adduser -D -s /sbin/nologin -h /dev/null -g php-fpm php-fpm
echo "chdir = $CHDIR" >> /etc/supervisord.conf
curl -sS https://getcomposer.org/installer | \
php -- --install-dir=/usr/bin --filename=composer
