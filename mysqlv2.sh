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

PRINT "Uninstall Plugin Validate Password"
echo "show plugins" | mysql -uroot -p${ROBOSHOP_MYSQL_PASSWORD} | grep validate_password &>>$LOG
if [ $? -eq 0 ]; then
  echo "uninstall plugin validate_password;" | mysql -uroot -p${ROBOSHOP_MYSQL_PASSWORD} &>>$LOG
fi
STAT $?

APP_LOC=/tmp
CONTENT=mysql-main
DOWNLOAD_APP_CODE

cd ${CONTENT} &>>$LOG

PRINT "LOAD SHIPPING SCHEMA"
mysql -u root -p${ROBOSHOP_MYSQL_PASSWORD} <shipping.sql &>>$LOG
STAT $?