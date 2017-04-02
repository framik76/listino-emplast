FROM ubuntu:16.04

MAINTAINER Francesco Manenti <francesco@manenti.net>
LABEL Description="Cutting-edge LAMP stack, based on Ubuntu 16.04 LTS. Includes .htaccess support and popular PHP7 features, including composer and mail() function." \
	License="Apache License 2.0" \
	Usage="docker run -d -p [HOST WWW PORT NUMBER]:80 -p [HOST DB PORT NUMBER]:3306 -v [HOST WWW DOCUMENT ROOT]:/var/www/html -v [HOST DB DOCUMENT ROOT]:/var/lib/mysql framik76/listino-emplast" \
	Version="1.0"

RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install -y \
	php7.0 \
	php7.0-bz2 \
	php7.0-cgi \
	php7.0-cli \
	php7.0-common \
	php7.0-curl \
	php7.0-dev \
	php7.0-enchant \
	php7.0-fpm \
	php7.0-gd \
	php7.0-gmp \
	php7.0-imap \
	php7.0-interbase \
	php7.0-intl \
	php7.0-json \
	php7.0-ldap \
	php7.0-mcrypt \
	php7.0-mysql \
	php7.0-odbc \
	php7.0-opcache \
	php7.0-pgsql \
	php7.0-phpdbg \
	php7.0-pspell \
	php7.0-readline \
	php7.0-recode \
	php7.0-snmp \
	php7.0-sqlite3 \
	php7.0-sybase \
	php7.0-tidy \
	php7.0-xmlrpc \
	php7.0-xsl
RUN apt-get install apache2 libapache2-mod-php7.0 -y
RUN apt-get install mariadb-common mariadb-server mariadb-client -y
RUN apt-get install git nodejs npm composer nano tree vim curl ftp -y

# Calculate download URL
ENV VERSION 4.6.6
ENV URL https://files.phpmyadmin.net/phpMyAdmin/${VERSION}/phpMyAdmin-${VERSION}-all-languages.tar.gz
LABEL version=$VERSION

RUN curl --output phpMyAdmin.tar.gz --location $URL
RUN tar xzf phpMyAdmin.tar.gz
RUN rm -f phpMyAdmin.tar.gz
RUN mv phpMyAdmin-$VERSION-all-languages /var/www/html/phpmyadmin
RUN mv /var/www/html/phpmyadmin/doc/html /var/www/html/phpmyadmin/htmldoc
RUN rm -rf /var/www/html/phpmyadmin/doc
RUN mkdir /var/www/html/phpmyadmin/doc
RUN mv /var/www/html/phpmyadmin/htmldoc /var/www/html/phpmyadmin/doc/html
RUN rm /var/www/html/phpmyadmin/doc/html/.buildinfo /var/www/html/phpmyadmin/doc/html/objects.inv
RUN rm -rf /var/www/html/phpmyadmin/js/jquery/src/ /var/www/html/phpmyadmin/js/openlayers/src/ /var/www/html/phpmyadmin/setup/ /var/www/html/phpmyadmin/examples/ /var/www/html/phpmyadmin/test/ /var/www/html/phpmyadmin/po/ /var/www/html/phpmyadmin/templates/test/ /var/www/html/phpmyadmin/phpunit.xml.* /var/www/html/phpmyadmin/build.xml  /var/www/html/phpmyadmin/composer.json /var/www/html/phpmyadmin/RELEASE-DATE-$VERSION
RUN sed -i "s@define('CONFIG_DIR'.*@define('CONFIG_DIR', '/etc/phpmyadmin/');@" /var/www/html/phpmyadmin/libraries/vendor_config.phpà
# RUN chown -R root:nobody /var/www/html/phpmyadmin
# RUN find /var/www/html/phpmyadmin -type d -exec chmod 750 {} \;
# RUN find /var/www/html/phpmyadmin -type f -exec chmod 640 {} \;

ENV LOG_STDOUT **Boolean**
ENV LOG_STDERR **Boolean**
ENV LOG_LEVEL warn
ENV ALLOW_OVERRIDE All
ENV DATE_TIMEZONE UTC
ENV TERM dumb

COPY run-lamp.sh /usr/sbin/

RUN a2enmod rewrite
RUN ln -s /usr/bin/nodejs /usr/bin/node
RUN chmod +x /usr/sbin/run-lamp.sh
RUN chown -R www-data:www-data /var/www/html

# VOLUME /var/www/html
# VOLUME /var/log/httpd
# VOLUME /var/lib/mysql
# VOLUME /var/log/mysql

EXPOSE 80
EXPOSE 3306

CMD ["/usr/sbin/run-lamp.sh"]
