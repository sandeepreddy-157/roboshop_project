#MySQL is the database service which is needed for the application. So we need to install it and configure it for the application to work.
## **Manual Steps to Install MySQL**

#As per the Application need, we are choosing MySQL 5.7 version.

#1. Setup Repo
#On Centos-7

# curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo

#On Centos-8

echo -e "\e[31m DOWNLOADING MYSQL REPO FILE\e[0m"

curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo
if [ $? -eq 0 ]
then
  echo -e "\e[32m SUCCESS\e[0m"
else
  echo FAILURE
fi

echo "DISABLE MODULE FOR MYSQL 8 VERSION REPO"
dnf module disable mysql -y

if [ $? -eq 0 ]
then
  echo -e "\e[32m SUCCESS\e[0m"
else
  echo FAILURE
fi
#Install MySQL

echo "INSTALLING MYSQL SERVER"
yum install mysql-community-server -y
if [ $? -eq 0 ]
then
  echo -e "\e[32m SUCCESS\e[0m"
else
  echo FAILURE
fi

#Start MySQL
echo "ENABLING MYSQL SERVICE"
systemctl enable mysqld
if [ $? -eq 0 ]
then
  echo -e "\e[32m SUCCESS\e[0m"
else
  echo FAILURE
fi

echo "START MYSQL SERVICE"

systemctl start mysqld
if [ $? -eq 0 ]
then
  echo -e "\e[32m SUCCESS\e[0m"
else
  echo FAILURE
fi

echo show databases | mysql -uroot -pRoboShop@1
if [ $? -ne 0 ]
then
  echo "ALTER USER 'root'@'localhost' IDENTIFIED BY 'RoboShop@1';" > /tmp/root-pass-sql
  DEFAULT_PASSWORD=$(sudo grep 'A temporary password' /var/log/mysqld.log | awk '{print $NF}')
  cat /tmp/root-pass-sql | mysql --connect-expired-password -uroot -p"${DEFAULT_PASSWORD}"
fi
