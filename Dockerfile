FROM ubuntu:16.04

LABEL maintainer="vanbakhanh@gmail.com"

# Interactive dialogue
ENV DEBIAN_FRONTEND=noninteractive

# Install Libraries
RUN apt-get update && \
    apt-get install -y curl \
    software-properties-common

# Install Supervisor
RUN apt-get install -y supervisor

# Install Apache
RUN apt-get install -y apache2

# Install Nginx
RUN apt-get install -y nginx

# Install PHP 7.2
RUN LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php
RUN apt-get update && \
    apt-get install -y libapache2-mod-php7.2 \
    php7.2 \
    php7.2-cli \
    php7.2-common \
    php7.2-curl \
    php7.2-gd \
    php7.2-json \
    php7.2-mbstring \
    php7.2-intl \
    php7.2-mysql \
    php7.2-xml \
    php7.2-zip \
    php7.2-cgi \
    php7.2-xsl \
    php7.2-fpm

# Install Composer
RUN curl -sS https://getcomposer.org/installer -o composer-setup.php
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer

# Configure vhost Apache
COPY docker/apache/vhost.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite

# Configure vhost Nginx
COPY docker/nginx/vhost /etc/nginx/sites-available/default

# Configure supervisor
COPY docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80 443

WORKDIR /var/www/html

# Default command
CMD ["/usr/bin/supervisord"]
