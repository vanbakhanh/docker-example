FROM centos:7

LABEL maintainer="vanbakhanh@gmail.com"

# Interactive dialogue
ENV DEBIAN_FRONTEND=noninteractive

# Install Libraries & Runtime
RUN yum -y update && yum -y install curl software-properties-common vim yum-utils epel-release

# Install PHP7.2
RUN yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
RUN yum-config-manager --enable remi-php72
RUN yum -y install php72 php72-php-fpm php72-php-mysqlnd php72-php-opcache php72-php-xml php72-php-xmlrpc php72-php-gd php72-php-mbstring php72-php-json
RUN ln -s /usr/bin/php72 /usr/bin/php

# Install Composer
RUN curl -sS https://getcomposer.org/installer -o composer-setup.php
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer

# Install Supervisor
RUN yum -y install supervisor

# Install Apache
# RUN yum -y install httpd

# Install Nginx
RUN yum -y install nginx

# Cleanup
RUN yum clean all

# Configure vhost Apache
# COPY docker/apache/vhost.conf /etc/httpd/example.com.conf

# Configure vhost Nginx
COPY docker/nginx/vhost /etc/nginx/conf.d/example.conf

# Configure supervisor
COPY docker/supervisord.conf /etc/supervisord.conf

# Copy entrypoint shell script
COPY docker/entrypoint.sh /
RUN chmod +x /entrypoint.sh

EXPOSE 80 443

WORKDIR /usr/share/nginx/example

ENTRYPOINT ["/entrypoint.sh"]