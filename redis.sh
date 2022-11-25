#!/bin/bash

#Redis is used for in-memory data storage and allows users to access the data over API.
#**Manual Installation of Redis.**

# Install Redis

Install Redis on CentOS-7

# curl -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo
# yum install redis-6.2.7 -y


#Install Redis on CentOS-8

dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
dnf module enable redis:remi-6.2 -y
yum install redis -y


#Update the bind from 127.0.0.1 to 0.0.0.0 in config file /etc/redis.conf & /etc/redis/redis.conf

sed 's/127.0.0.1/0.0.0.0/' /etc/redis.conf; /etc/redis/redis.conf

#3. Start Redis Database

systemctl enable redis
systemctl start redis
