#MySQL is the database service which is needed for the application. So we need to install it and configure it for the application to work.
## **Manual Steps to Install MySQL**

#As per the Application need, we are choosing MySQL 5.7 version.

#1. Setup Repo
#On Centos-7

# curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo

#On Centos-8

curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo
dnf module disable mysql -y

#Install MySQL

yum install mysql-community-server -y

#Start MySQL

systemctl enable mysqld
systemctl start mysqld

echo show databases | mysql -uroot -pRoboShop@1
if [$? -ne 0]
then
  echo "ALTER USER 'root'@'localhost' IDENTIFIED BY 'RoboShop@1';" > /tmp/root-pass-sql
  DEFAULT_PASSWORD=$(sudo grep 'A temporary password' /var/log/mysqld.log | awk '{print $NF}')
  cat /tmp/root-pass-sql | mysql --connect-expired-password -uroot -p"${DEFAULT_PASSWORD}"
fi
