FROM --platform=linux/amd64 ubuntu:latest

MAINTAINER Roman Povoroznyk

ENV TZ=Europe/Kiev
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && \
    apt-get install -y apt-utils \
                       apache2

RUN  DEBIAN_FRONTEND=noninteractive apt-get install -y libapache2-mod-php \
                                                       php \
                                                       php-mysql \
                                                       wget
RUN echo '<IfModule mod_dir.c> \n\
 DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm \n\
</IfModule> ' > /etc/apache2/mods-enabled/dir.conf

RUN echo 'ServerName localhost' >> /etc/apache2/apache2.conf

WORKDIR /tmp
ADD 000-default.conf /tmp
COPY 000-default.conf /etc/apache2/sites-available/

RUN wget -nc https://wordpress.org/latest.tar.gz
RUN tar xzvf latest.tar.gz && \
    touch wordpress/.htaccess && \
    mkdir -p wordpress/wp-content/upgrade && \
    cp -r wordpress/. /var/www/html

RUN chown -R www-data:www-data /var/www/html && \
    find /var/www/html/ -type d -exec chmod 750 {} \; && \
    find /var/www/html/ -type f -exec chmod 640 {} \;

RUN rm -rf /tmp/*

EXPOSE 80
ENTRYPOINT ["apachectl", "-D", "FOREGROUND"]