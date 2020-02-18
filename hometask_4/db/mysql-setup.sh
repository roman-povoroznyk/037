#!/bin/bash
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf
mkdir -p /var/run/mysqld && chown mysql:mysql /var/run/mysqld