# **Cart Service**

#This service is responsible for Cart Service in RobotShop e-commerce portal.
#This service is written in NodeJS, Hence need to install NodeJS in the system.
#On CentOS-7

# curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash -
# yum install nodejs -y


#On CentOS-8

COMPONENT=cart
source common.sh
PRINT "SETUP REPO FILE FOR ROBOSHOP PROJECT"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash  >>$LOG
STAT $?

PRINT "INSTALLING NODEJS"
yum install nodejs -y &>>$LOG
STAT $?
#Let's now set up the cart application.

#As part of operating system standards, we run all the applications and databases as a normal user but not with root user.
#So to run the cart service we choose to run as a normal user and that user name should be more relevant to the project. Hence we will use `roboshop` as the username to run the service.
PRINT "ADDING ROBOSHOP USER"
useradd roboshop &>>$LOG
STAT &?

#So let's switch to the roboshop user and run the following commands to download the application code and download application dependencies
PRINT "DOWNLOADING THE APPLICATION CODE"
curl -s -L -o /tmp/cart.zip "https://github.com/roboshop-devops-project/cart/archive/main.zip" &>>$LOG
cd /home/roboshop &>>$LOG
rm -rf cart
STAT $?

PRINT "EXTRACTING APP CONTENT"
unzip -o /tmp/cart.zip &>>$LOG
mv cart-main cart
cd cart
STAT $?

PRINT " INSTALLING REQUIRED DEPENDENCIES FOR APP"
npm install &>>LOG
STAT $?

PRINT "Update SystemD service file"
PRINT "Update REDIS_ENDPOINT with REDIS server IP Address and Update CATALOGUE_ENDPOINT with Catalogue server IP address"

sed -i -e 's/REDIS_ENDPOINT/redis.happylearning.buzz/' -e 's/CATALOGUE_ENDPOINT/catalogue.happylearning.buzz/' /home/roboshop/cart/systemd.service >>$LOG

#Now, lets set up the service with systemctl.

PRINT "SET UP THE SERVICE WITH SYSTEMCTL"

mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service &>>LOG
systemctl daemon-reload &>>LOG
STAT $?

PRINT "RESTARTING CART SERVICE"
systemctl restart cart &>>LOG
systemctl enable cart &>>LOG
STAT $?
