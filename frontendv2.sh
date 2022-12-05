COMPONENT=frontend
CONTENT="*"
source common.sh

PRINT "INSTALLING NGINX "
sudo yum install nginx -y &>>$LOG
STAT $?

APP_LOC=/usr/share/nginx/html

DOWNLOAD_APP_CODE
exit

sudo systemctl enable nginx
sudo systemctl start nginx

#Let's download the HTDOCS content and deploy under the Nginx path.

curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"

#Deploy the downloaded content in Nginx Default Location.

cd /usr/share/nginx/html
rm -rf *
unzip /tmp/frontend.zip
mv frontend-main/static/* .
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf

#Finally restart the service once to effect the changes.

systemctl restart nginx

