#!/usr/bin/env bash
docker network create localnetwork --subnet=192.168.0.0/16 --gateway=192.168.0.1
docker network connect localnetwork db
docker network connect localnetwork wp
docker exec db mysql -u root -p --skip-password -e "CREATE DATABASE wordpress CHARACTER SET utf8;"
docker exec db mysql -u root -p --skip-password -e "CREATE USER 'wordpress'@'192.168.0.3' IDENTIFIED BY 'wordpress';"
docker exec db mysql -u root -p --skip-password -e "GRANT ALL ON wordpress.* TO 'wordpress'@'192.168.0.3';"
docker exec db mysql -u root -p --skip-password -e "FLUSH PRIVILEGES;"
docker exec wp a2enmod ssl
docker exec wp a2enmod headers
docker exec wp a2ensite default-ssl
docker exec wp a2enconf ssl-params
docker exec wp apachectl restart
echo -e "Username: wordpress\nPassword: wordpress\nDatabase: wordpress\nLocalhost: 192.168.0.2\n80 -> localhost:8080\m443 -> localhost:8081\P.S. No redirect" 
