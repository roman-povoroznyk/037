#!/usr/bin/env bash
MAIN_FOLDER="/vagrant"
SERVER_FILE=$MAIN_FOLDER/"atlassian-confluence-7.3.1-x64.bin"
apt-get update
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt update
apt install -y docker-ce

docker run -d -p 80:80 --name mysql romashultz/mysql
docker run -d --name apache-wordpress romashultz/apache-wordpress
docker network create wp-msql
docker network connect wp-msql mysql
docker network connect wp-msql apache-wordpress
docker exec mysql mysql -u root -p --skip-password -e "CREATE DATABASE wordpress;"
docker exec mysql mysql -u root -p --skip-password -e "CREATE USER 'wordpress'@'172.18.0.3' IDENTIFIED BY 'wordpress';"
docker exec mysql mysql -u root -p --skip-password -e "GRANT ALL ON wordpress.* TO 'wordpress'@'172.18.0.3';"
docker exec apache-wordpress chown -R www-data:www-data /var/www/html
echo -e "Username: wordpress\nPassword: wordpress\nDatabase: wordpress\nLocalhost: 172.18.0.3" 
