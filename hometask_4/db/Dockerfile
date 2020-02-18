FROM --platform=linux/amd64 ubuntu:latest

MAINTAINER Roman Povoroznyk

#ENV MYSQL_ROOT_PASSWORD=123456

RUN apt-get update && \
    apt-get install -y mysql-server

ADD mysql-setup.sh /
RUN chmod +x /mysql-setup.sh && \
    /mysql-setup.sh

ENTRYPOINT ["mysqld_safe"]