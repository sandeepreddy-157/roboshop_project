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

 NODEJS() {
   PRINT "Install NodeJS Repos"
   curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOG
   STAT $?


    PRINT "Adding Application User"
    id roboshop &>>$LOG
    if [ $? -ne 0 ]; then
      useradd roboshop &>>$LOG
    fi
    STAT $?


  PRINT "Download App Content"
  curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>$LOG
  STAT $?

  PRINT "Remove Previous Version of App"
  cd /home/roboshop &>>$LOG
  rm -rf ${COMPONENT} &>>$LOG
  STAT $?

  PRINT "Extracting App Content"
  unzip -o /tmp/${COMPONENT}.zip &>>$LOG
  STAT $?

  mv ${COMPONENT}-main ${COMPONENT}
  cd ${COMPONENT}

  PRINT "Install NodeJS Dependencies for App "
  npm install &>>$LOG
  STAT $?

  PRINT "Configure Endpoints for SystemD Configuration"
  sed -i -e 's/REDIS_ENDPOINT/cart.happylearning.com/' -e 's/CATALOGUE_ENDPOINT/catalogue.happylearning.com/' /home/roboshop/${COMPONENT}/systemd.service &>>$LOG
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

