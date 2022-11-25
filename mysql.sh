#MySQL is the database service which is needed for the application. So we need to install it and configure it for the application to work.
## **Manual Steps to Install MySQL**

#As per the Application need, we are choosing MySQL 5.7 version.

#1. Setup Repo
#On Centos-7

# curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo

#On Centos-8

curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo
dnf module disable mysql

#Install MySQL

yum install mysql-community-server -y

#Start MySQL

systemctl enable mysqld
systemctl start mysqld