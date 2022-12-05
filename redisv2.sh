COMPONENT=redis
source common.sh
#Redis is used for in-memory data storage and allows users to access the data over API.
#**Manual Installation of Redis.**

# Install Redis

#Install Redis on CentOS-7

# curl -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo
# yum install redis-6.2.7 -y

PRINT "Install Redis Repo File For CentOS-8"
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$LOG
STAT $?

PRINT "Enable Redis Repo 6.2"
dnf module enable redis:remi-6.2 -y  &>>$LOG
STAT $?

PRINT "Installing Redis Service"
yum install redis -y &>>$LOG
STAT $?

PRINT "Updating Redis Listen IP address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf &>>$LOG
STAT $?

PRINT "Enable Redis Service"
systemctl enable redis &>>$LOG
STAT $?

PRINT "Restarting Redis Service"
systemctl start redis &>>$LOG
STAT $?
