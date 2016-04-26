FROM php:5.5-apache
MAINTAINER corbinu <corbinu@openswimsoftware.com>

ENV N98_MAGERUN_VERSION 1.97.19
ENV N98_MAGERUN_URL https://raw.githubusercontent.com/netz98/n98-magerun/$N98_MAGERUN_VERSION/n98-magerun.phar
ENV MAGENTO_VERSION 1.9.2.4
ENV MAGENTO_DOWNLOAD_URL https://codeload.github.com/OpenMage/magento-mirror/tar.gz/$MAGENTO_VERSION

ENV TERM=xterm

RUN curl -o /usr/local/bin/n98-magerun $N98_MAGERUN_URL \
    && chmod +x /usr/local/bin/n98-magerun

RUN requirements="nano cron mysql-client-5.5 libpng12-dev libmcrypt-dev libmcrypt4 libcurl3-dev libxml2-dev libfreetype6 libjpeg62-turbo libpng12-dev libfreetype6-dev libjpeg62-turbo-dev" \
    && apt-get update && apt-get install -y --no-install-recommends $requirements && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && docker-php-ext-install mcrypt \
    && docker-php-ext-install mbstring \
    && docker-php-ext-install soap \
    && requirementsToRemove="libpng12-dev libmcrypt-dev libcurl3-dev libxml2-dev libpng12-dev libfreetype6-dev libjpeg62-turbo-dev" \
    && apt-get purge --auto-remove -y $requirementsToRemove

RUN usermod -u 1000 www-data
RUN a2enmod rewrite
RUN sed -i -e 's/\/var\/www\/html/\/var\/www\/htdocs/' /etc/apache2/apache2.conf

WORKDIR /var/www/htdocs

RUN chown -R www-data:www-data /var/www/htdocs

COPY ./bin/* /usr/local/bin/
COPY ./conf/apache2.conf /etc/apache2/apache2.conf

RUN chmod +x /usr/local/bin/mage-setup

COPY ./magento-sample-data-1.9.1.0.tgz /opt/
