STAT() {
  if [ $1 -eq 0 ]
  then
    echo -e "\e[32m SUCCESS\e[0m"
  else
    echo -e "\e[31m FAILURE\e[0m"
    exit 1
  fi
}

PRINT() {
  echo -e "\e[33m$1\e[0m"
}

LOG=/tmp/$COMPONENT.log
rm -rf $LOG

STAT() {
  if [ $1 -eq 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILURE\e[0m"
    echo Check the error in $LOG file
    exit 1
  fi
}

LOG=/tmp/$COMPONENT.log
rm -f $LOG

DOWNLOAD_APP_CODE() {
  if [ ! -z $APP_USER ]; then
    PRINT "Adding Application User"
        id roboshop &>>$LOG
        if [ $? -ne 0 ]; then
          useradd roboshop &>>$LOG
        fi
        STAT $?
       fi

      PRINT "Download App Content"
      curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>$LOG
      STAT $?

      PRINT "Remove Previous Version of App "
      cd ${APP_LOC} &>>$LOG
      rm -rf ${CONTENT} &>>$LOG
      STAT $?

      PRINT "Extracting APP Content"
      unzip -o /tmp/${COMPONENT}.zip &>>$LOG
      STAT $?
}



 NODEJS() {
   APP_LOC=/home/roboshop
   CONTENT=$COMPONENT
   APP_USER=roboshop
   PRINT "Install NodeJS Repos"
   curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOG
   STAT $?

    PRINT "Adding Application User"
    id roboshop &>>$LOG
    if [ $? -ne 0 ]; then
      useradd roboshop &>>$LOG
    fi
    STAT $?

  DOWNLOAD_APP_CODE


  mv ${COMPONENT}-main ${COMPONENT}
  cd ${COMPONENT}

  PRINT "Install NodeJS Dependencies for App "
  npm install &>>$LOG
  STAT $?

  SYSTEMD_SETUP

}

SYSTEMD_SETUP() {
   PRINT "Configure Endpoints for SystemD Configuration"
   sed -i -e 's/MONGO_DNSNAME/dev-mongodb.happylearning.buzz/' -e 's/REDIS_ENDPOINT/dev-redis.happylearning.buzz/' -e 's/CATALOGUE_ENDPOINT/dev-catalogue.happylearning.buzz/' -e 's/MONGO_ENDPOINT/dev-mongodb.happylearning.buzz/' -e 's/CARTENDPOINT/dev-cart.happylearning.buzz/' -e 's/DBHOST/dev-mysql.happylearning.buzz/' -e 's/AMQPHOST/dev-rabbitmq.happylearning.buzz/' -e 's/CARTHOST/dev-cart.happylearning.buzz/' -e 's/USERHOST/dev-user.happylearning.buzz/' /home/roboshop/${COMPONENT}/systemd.service &>>$LOG
   mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service
   STAT $?

    PRINT "reload systemd"
    systemctl daemon-reload &>>$LOG
    STAT $?

    PRINT "RESTART ${COMPONENT}"
    systemctl restart ${COMPONENT} &>>$LOG
     STAT $?

    PRINT "ENABLE ${COMPONENT} SERVICE"
    systemctl enable ${COMPONENT} &>>$LOG
    STAT $?

}
JAVA() {
  APP_LOC=/home/roboshop
  CONTENT=$COMPONENT
  APP_USER=roboshop

  PRINT "Install Maven"
  yum install maven -y  &>>$LOG
  STAT $?

  DOWNLOAD_APP_CODE

  mv ${COMPONENT}-main ${COMPONENT}
  cd ${COMPONENT}

  PRINT "Download Maven Dependencies"
  mvn clean package &>>$LOG  && mv target/$COMPONENT-1.0.jar $COMPONENT.jar &>>$LOG
  STAT $?

  SYSTEMD_SETUP

}

RABBITMQ_USER() {

  if [ ! -z  "$APP_USER" ]; then
      PRINT "Adding Application User"
      rabbitmqctl authenticate_user $APP_USER  ${RABBITMQ_APP_USER_PASSWORD}  &>>$LOG

      if [ $? -ne 0 ]; then
        rabbitmqctl add_user roboshop ${RABBITMQ_APP_USER_PASSWORD}  &>>$LOG
      fi
      STAT $?
    fi

    PRINT "Configure Application User Tags"
    rabbitmqctl set_user_tags roboshop administrator  &>>$LOG
    STAT $?


    PRINT "Configure Application User Permissions"
    rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"  &>>$LOG
    STAT $?
}

PYTHON() {
    APP_LOC=/home/roboshop
    CONTENT=$COMPONENT
    APP_USER=roboshop

  PRINT "INSTALLING PYTHON-3"
  yum install python36 gcc python3-devel -y &>>LOG
  STAT $?

  DOWNLOAD_APP_CODE

  mv ${COMPONENT}-main ${COMPONENT}

  cd ${COMPONENT}

  PRINT "INSTALLING DEPENDENCIES"

  pip3 install -r requirements.txt &>>$LOG
  STAT $?

  PRINT "Updating the roboshop user id and group id in payment.ini file"
  User_ID=$(id -u roboshop)
  Group_ID=$(id -g roboshop)
  sed -i -e 's/$uid/$User_ID/' -e 's/$gid/$Group_ID/' payment.ini &>>LOG
  STAT $?
}