#!/bin/bash -xe

sudo bash

yum -y update
yum -y upgrade

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

cd /var
mkdir www
cd www
mkdir testangularapp
cd testangularapp

aws s3 cp s3://app-deployables-us/angularapp/ /var/www/testangularapp --recursive

cd ../../
chmod 0775 -R www

amazon-linux-extras install nginx1 -y
systemctl enable nginx
systemctl start nginx

cd /etc/nginx
line_old='/usr/share/nginx/html'
line_new='/var/www/testangularapp'
sed -i "s%$line_old%$line_new%g" /etc/nginx/nginx.conf
line_old='/var/www/testangularapp;'
line_new='/var/www/testangularapp;location \/ {try_files $uri $uri\/ \/index.html;}'
sed -i "s%$line_old%$line_new%g" /etc/nginx/nginx.conf

systemctl restart nginx