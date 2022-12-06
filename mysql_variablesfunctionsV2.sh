#MySQL is the database service which is needed for the application. So we need to install it and configure it for the application to work.
## **Manual Steps to Install MySQL**

#As per the Application need, we are choosing MySQL 5.7 version.

#1. Setup Repo
#On Centos-7

# curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo

#On Centos-8

COMPONENT=mysql
source common.sh

if [ -z '$1']; then
  echo "input argument password is needed"
  exit 1
fi
ROBOSHOP_MYSQL_PASSWORD=$1


PRINT "DOWNLOADING MYSQL REPO FILE"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo  &>>$LOG
STAT $?

PRINT "DISABLE MODULE FOR MYSQL 8 VERSION REPO"
dnf module disable mysql -y &>>$LOG
STAT $?

#Install MySQL

PRINT "INSTALLING MYSQL SERVER"
yum install mysql-community-server -y &>>$LOG
STAT $?

#Start MySQL
PRINT "ENABLING MYSQL SERVICE"
systemctl enable mysqld &>>$LOG
STAT $?

PRINT "START MYSQL SERVICE"

systemctl start mysqld &>>$LOG
STAT $?

echo show databases | mysql -uroot -p${ROBOSHOP_MYSQL_PASSWORD}  &>>$LOG
if [ $? -ne 0 ]
then
  echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '${ROBOSHOP_MYSQL_PASSWORD}';" > /tmp/root-pass-sql
  DEFAULT_PASSWORD=$(sudo grep 'A temporary password' /var/log/mysqld.log | awk '{print $NF}')
  cat /tmp/root-pass-sql | mysql --connect-expired-password -uroot -p"${DEFAULT_PASSWORD}" &>>$LOG
fi

#while executing we need to pri
