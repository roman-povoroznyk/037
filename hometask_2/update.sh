#!/bin/bash

sudo apt-get update -y &>> /var/log/update-$(date +%Y%m%d).log
sudo apt-get upgrade -y &>> /var/log/update-$(date +%Y%m%d).log
sudo apt-get full-upgrade -y &>> /var/log/update-$(date +%Y%m%d).log
sudo apt-get autoremove -y &>> /var/log/update-$(date +%Y%m%d).log
