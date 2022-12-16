COMPONENT=dispatch
source common.sh

#Dispatch is the service which dispatches the product after purchase. It is written in GoLang, So wanted to install GoLang.

PRINT "Installing  GoLang"
yum install golang -y &>>LOG
STAT $?

1. Add roboshop User

```bash
# useradd roboshop
```

1. Switch to roboshop user and perform the following commands.

```bash
$ curl -L -s -o /tmp/dispatch.zip https://github.com/roboshop-devops-project/dispatch/archive/refs/heads/main.zip
$ unzip /tmp/dispatch.zip
$ mv dispatch-main dispatch
$ cd dispatch
$ go mod init dispatch
$ go get
$ go build
```

1. Update the systemd file and configure the dispatch service in systemd