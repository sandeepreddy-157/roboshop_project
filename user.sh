# 05-User

#This service is responsible for User Logins and Registrations Service in RobotShop e-commerce portal.

#This service is written in NodeJS, Hence need to install NodeJS in the system.

#On CentOS-7
# curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash -
# yum install nodejs -y

#On CentOS-8

curl -sL https://rpm.nodesource.com/setup_lts.x | bash
yum install nodejs -y

#1. Let's now set up the User application.
#As part of operating system standards, we run all the applications and databases as a normal user but not with root user.
#So to run the User service we choose to run as a normal user and that user name should be more relevant to the project. Hence we will use `roboshop` as the username to run the service.

useradd roboshop

curl -s -L -o /tmp/user.zip "https://github.com/roboshop-devops-project/user/archive/main.zip"
cd /home/roboshop
rm -rf user
unzip -o /tmp/user.zip
mv user-main user
cd /home/roboshop/user
npm install


#Update SystemD service file,
#Update `REDIS_ENDPOINT` with Redis Server IP
# Update `MONGO_ENDPOINT` with MongoDB Server IP

sed -i -e 's/REDIS_ENDPOINT/redis.happylearning.buzz/' -e 's/MONGO_ENDPOINT/mongo.happylearning.buzz/' systemd.service

#2. Now, lets set up the service with systemctl.

mv /home/roboshop/user/systemd.service /etc/systemd/system/user.service
systemctl daemon-reload
systemctl start user
systemctl enable user