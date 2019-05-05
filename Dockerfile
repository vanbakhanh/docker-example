FROM centos:7
ENV container docker
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]

LABEL maintainer="vanbakhanh@gmail.com"

# Interactive dialogue
ENV DEBIAN_FRONTEND=noninteractive

# Install Libraries & Runtime
RUN yum -y update && yum -y install curl software-properties-common vim yum-utils epel-release

# Install PHP7.2
RUN yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
RUN yum-config-manager --enable remi-php72
RUN yum -y install php php-fpm php-common php-opcache php-pecl-apcu php-cli php-pear php-pdo php-mysqlnd php-pgsql php-pecl-mongodb php-pecl-redis php-pecl-memcache php-pecl-memcached php-gd php-mbstring php-mcrypt php-xml

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
# COPY apache/vhost.conf /etc/httpd/example.com.conf

# Configure vhost Nginx
COPY nginx/vhost /etc/nginx/conf.d/example.conf

# Configure supervisor
COPY supervisord.conf /etc/supervisord.conf

# Copy entrypoint shell script
COPY entrypoint.sh /etc/
RUN chmod +x /etc/entrypoint.sh

EXPOSE 80 443

WORKDIR /usr/share/nginx/example

CMD ["/usr/sbin/init"]

# ENTRYPOINT ["/etc/entrypoint.sh"]