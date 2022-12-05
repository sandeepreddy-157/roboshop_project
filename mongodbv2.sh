COMPONENT=mongodb

PRINT "DOWNLOAD REPO FILE FOR MongoDB"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>$LOG
STAT $?

PRINT "INSTALLING MONGODB SERVICE"
yum install -y mongodb-org &>>$LOG
STAT $?

PRINT "CONFIGURE MONGODB LISTEN ADDRESS"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>$LOG
STAT $?

PRINT "ENABLE MONGODB SERVICE"
systemctl enable mongod &>>$LOG
STAT $?

PRINT "RESTARTING MONGODB SERVICE"
systemctl restart mongod &>>$LOG
STAT $?


## Every Database needs the schema to be loaded for the application to work.

#Download the schema and load it.
APP_LOC=/tmp
CONTENT=mongodb-main
DOWNLOAD_APP_CODE

cd ${CONTENT} &>>$LOG

PRINT "LOAD CATALOGUE SCHEMA"
mongo < catalogue.js &>>$LOG
STAT $?

PRINT "LOAD USERS SCHEMA"
mongo < users.js &>>$LOG
STAT $?

#Symbol `<` will take the input from a file and give that input to the command.