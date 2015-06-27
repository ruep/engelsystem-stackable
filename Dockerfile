FROM tutum/apache-php:latest
MAINTAINER Marc Gehling <m.gehling@gmx.de>

# Install packages 
RUN apt-get update && \
  apt-get -yq install mysql-client \
  git \
  gettext \
  msmtp \
  && rm -rf /var/lib/apt/lists/*

# Add permalink feature
RUN a2enmod rewrite

# Download latest version of engelsystem into /engelsystem
RUN git clone --recursive https://github.com/engelsystem/engelsystem.git /engelweb \ 
  && mv /app /app_old \
  && ln -s /engelweb/public /app

ADD config.php /engelweb/config/config.php
ADD patch-index.php /engelweb/public/patch-index.php
RUN patch /engelweb/public/index.php < /engelweb/public/patch-index.php

# Add config msmtp
Add .msmtprc /root/.msmtprc
RUN chmod 600 /root/.msmtprc \
  && mkdir /var/log/msmtp
# php.ini /etc/php5/apache2/php.ini sendmail_path = "/usr/bin/msmtp -C /etc/msmtprc -a engelgmail -t"
ADD patch-php.ini /root/patch-php.ini
RUN patch /etc/php5/apache2/php.ini < /root/patch-php.ini

# Add script to create 'wordpress' DB
ADD run-engelsystem.sh /run-engelsystem.sh
RUN chmod 755 /*.sh

# Modify permissions to allow plugin upload

# Expose environment variables
ENV DB_HOST **LinkMe**
ENV DB_PORT **LinkMe**
ENV DB_NAME engelsystem
ENV DB_USER admin
ENV DB_PASS **ChangeMe**

RUN chmod 755 /engelweb/db/install.sql \
  && chmod 777 /engelweb/import

EXPOSE 80
CMD ["/run-engelsystem.sh"] 


