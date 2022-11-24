# 03-Catalogue

#This service is responsible for showing the list of items that are to be sold by the RobotShop e-commerce portal.
#This service is written in NodeJS, Hence need to install NodeJS in the system.

#On CentOS-7

# curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash -
# yum install nodejs -y


#On CentOS-8

curl -sL https://rpm.nodesource.com/setup_lts.x | bash
yum install nodejs -y

#Let's now set up the catalogue application.
#As part of operating system standards, we run all the applications and databases as a normal user but not with root user.
#So to run the catalogue service we choose to run as a normal user and that user name should be more relevant to the project. Hence we will use `roboshop` as the username to run the service.

useradd roboshop

#So let's switch to the `roboshop` user and run the following commands.

curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip"
cd /home/roboshop
unzip -o /tmp/catalogue.zip
rm -rf catalogue
mv catalogue-main catalogue
cd /home/roboshop/catalogue
npm install

#Update SystemD file with correct IP addresses
#Update `MONGO_DNSNAME` with MongoDB Server IP