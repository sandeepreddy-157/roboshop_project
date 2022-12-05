COMPONENT=frontend
CONTENT="*"
source common.sh

PRINT "INSTALLING NGINX "
sudo yum install nginx -y &>>$LOG
STAT $?

APP_LOC=/usr/share/nginx/html

DOWNLOAD_APP_CODE

mv frontend-main/static/* .

PRINT "Copy RoboShop Configuration File"
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>$LOG
STAT $?

PRINT "ENABLE NGINX SERVICE"
sudo systemctl enable nginx &>>$LOG
STAT $?

PRINT "START NGINX SERVICE"
sudo systemctl start nginx &>>$LOG
STAT $?
