#RabbitMQ is a messaging Queue which is used by some components of the applications.
#Erlang is a dependency which is needed for RabbitMQ.
#while executing this script , we need to provide rabbitmq username and password on the commandline

#example  sudo bash rabbitmq.sh roboshop roboshop123
#here rabbitmq.sh is a script file , roboshop is a username of rabbitmq and roboshop123 is a password of roboshop
#here $0 means rabbitmq.sh $1 means roboshop $2 means roboshop123

COMPONENT=rabbitmq
source common.sh
APP_USER=$1
RABBITMQ_APP_USER_PASSWORD=$2

if [ -z "$1" ]; then
  echo "Input Password is missing"
  exit
fi

PRINT "Configure Erlang Repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash &>>$LOG
STAT $?

PRINT "Install Erlang"
yum install erlang -y  &>>$LOG
STAT $?


PRINT "Configure RabbitMQ repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash  &>>$LOG
STAT $?


PRINT "Install RabbitMQ"
yum install rabbitmq-server -y  &>>$LOG
STAT $?


PRINT "Enable RabbitMQ Service"
systemctl enable rabbitmq-server   &>>$LOG
STAT $?


PRINT "Start RabbitMQ Service"
systemctl start rabbitmq-server  &>>$LOG
STAT $?

RABBITMQ_USER


