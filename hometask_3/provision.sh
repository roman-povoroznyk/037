#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

debconf-set-selections <<< "mysql-server mysql-server/root_password password 123456"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password 123456"

apt-get install -y mysql-server

cd /vagrant

sed -i '/!includedir \/etc\/mysql\/conf.d\// i \
[mysqld] \
character-set-server=utf8 \
collation-server=utf8_bin \
transaction-isolation=READ-COMMITTED \
default-storage-engine=INNODB \
max_allowed_packet=34M \
innodb_log_file_size=2GB \
binlog_format=row \
' /etc/mysql/my.cnf

sed -ie '1,/16M/ s/16M/34M/' /etc/mysql/mysql.conf.d/mysqld.cnf  

/etc/init.d/mysql restart

mysql -uroot -p123456 -e "CREATE DATABASE CONFLUENCE CHARACTER SET utf8 COLLATE utf8_bin;"
mysql -uroot -p123456 -e "GRANT ALL PRIVILEGES ON CONFLUENCE.* TO 'root'@'localhost' IDENTIFIED BY '123456';"

cat << EOF > response.varfile
app.confHome=/var/atlassian/application-data/confluence
app.install.service$Boolean=true
httpPort$Long=8080
launch.application$Boolean=false
portChoice=custom
rmiPort$Long=8000
sys.adminRights$Boolean=true
sys.confirmedUpdateInstallationString=false
sys.installationDir=/opt/atlassian/confluence
sys.languageId=en
EOF

if [[ -f "atlassian-confluence-7.3.1-x64.bin" ]]
then 
	chmod a+x atlassian-confluence-7.3.1-x64.bin
else
	wget -nc https://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-7.3.1-x64.bin 
	chmod a+x atlassian-confluence-7.3.1-x64.bin
fi

./atlassian-confluence-7.3.1-x64.bin -q -varfile response.varfile	
/etc/init.d/confluence stop

mkdir -p /opt/atlassian/confluence/confluence/WEB-INF/lib

if [[ -f mysql-connector-java-5.1.48.tar.gz ]]
then
	tar -xf mysql-connector-java-5.1.48.tar.gz
	cp  mysql-connector-java-5.1.48/mysql-connector-java-5.1.48.jar /opt/atlassian/confluence/confluence/WEB-INF/lib
else 
	wget -nc https://cdn.mysql.com/Downloads/Connector-J/mysql-connector-java-5.1.48.tar.gz
	tar -xf mysql-connector-java-5.1.48.tar.gz
	cp mysql-connector-java-5.1.48/mysql-connector-java-5.1.48.jar /opt/atlassian/confluence/confluence/WEB-INF/lib
fi

/etc/init.d/mysql restart
/etc/init.d/confluence start

