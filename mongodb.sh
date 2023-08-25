#!/bin/bash


DATE=$(date +%F)
SCRIPT_NAME=$0
LOGSDIR=/tmp
LOGFILE=$LOGSDIR/$SCRIPT_NAME-$DATE.log

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

if [ $USERID -ne 0 ]
then
    echo -e "$R ERROR: Please run the script with Root access $N"
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 ... $R FAILURE $N"
        exit 1
    else
        echo -e "$2 ... $R SUCCESS $N"
    fi
}

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

VALIDATE $? "Copied MongoDB repo into yum repos.d"

yum install mongodb-org -y &>> $LOGFILE

VALIDATE $? "Installation of MongoDB"

systemctl enable mongod &>> $LOGFILE

VALIDATE $? "enable MongoDB"

systemctl start mongod &>> $LOGFILE

VALIDATE $? "start MongoDB"

sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>> $LOGFILE

VALIDATE $? "edited MongoDB"

systemctl restart mongod &>> $LOGFILE

VALIDATE $? "restart MongoDB"
