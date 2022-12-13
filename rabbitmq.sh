#RabbitMQ is a messaging Queue which is used by some components of the applications.
#Erlang is a dependency which is needed for RabbitMQ.


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


