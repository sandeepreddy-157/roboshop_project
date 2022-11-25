# **Cart Service**

#This service is responsible for Cart Service in RobotShop e-commerce portal.
#This service is written in NodeJS, Hence need to install NodeJS in the system.
#On CentOS-7

# curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash -
# yum install nodejs -y


#On CentOS-8

curl -sL https://rpm.nodesource.com/setup_lts.x | bash
yum install nodejs -y

#Let's now set up the cart application.

#As part of operating system standards, we run all the applications and databases as a normal user but not with root user.
#So to run the cart service we choose to run as a normal user and that user name should be more relevant to the project. Hence we will use `roboshop` as the username to run the service.

useradd roboshop

#So let's switch to the roboshop user and run the following commands to download the application code and download application dependencies

curl -s -L -o /tmp/cart.zip "https://github.com/roboshop-devops-project/cart/archive/main.zip"
cd /home/roboshop
rm -rf cart
unzip -o /tmp/cart.zip
mv cart-main cart
cd cart
npm install


#1. Update SystemD service file
#Update `REDIS_ENDPOINT` with REDIS server IP Address
#Update `CATALOGUE_ENDPOINT` with Catalogue server IP address

sed -i -e 's/REDIS_ENDPOINT/redis.happylearning.buzz/' -e 's/CATALOGUE_ENDPOINT/catalogue.happylearning.buzz/' systemd.service

#Now, lets set up the service with systemctl.

mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service
systemctl daemon-reload
systemctl restart cart
systemctl enable cart
