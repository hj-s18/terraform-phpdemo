#! /bin/bash

sudo yum install git
sudo yum install mysql
sudo amazon-linux-extras install epel

curl -O http://rpms.remirepo.net/enterprise/remi-release-7.rpm
sudo rpm -Uvh remi-release-7.rpm

sudo yum install -y yum-utils
sudo yum-config-manager --enable remi-php72
sudo yum install -y php php-common php-mysqli

sudo systemctl start httpd
sudo systemctl enable httpd
