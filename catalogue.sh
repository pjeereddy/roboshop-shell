echo -e '\e[32m<<<<<<<<<<<<<<<<< create catalogue service >>>>>>>>>>>>>>>>>>>>>\e[0m'
cp catalogue.service /etc/systemd/system/catalogue.service &>>/tmp/roboshop.log
echo -e '\e[32m<<<<<<<<<<<<<<<<< create mongodb repo >>>>>>>>>>>>>>>>>>>\e[0m'
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>/tmp/roboshop.log
echo -e '\e[32m<<<<<<<<<<<<<<<<< download nodejs setup >>>>>>>>>>>>>>>>>>\e[0m'
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/tmp/roboshop.log
echo -e '\e[32m<<<<<<<<<<<<<<<<<< install nodejs repos >>>>>>>>>>>>>>>>>>>>>>>\e[0m'
yum install nodejs -y &>>/tmp/roboshop.log
echo -e '\e[32m<<<<<<< add user >>>>>>>>>>>>\e[0m'
useradd roboshop &>>/tmp/roboshop.log
echo -e '\e[32m<<<<<<<<< remove directory APP >>>>>>>>>>>>>>>>\e[0m'
rm -rf /app &>>/tmp/roboshop.log
echo -e '\e[32m<<<<<<<<<< create new directory APP >>>>>>>>>>>>>>\e[0m'
mkdir /app &>>/tmp/roboshop.log
echo -e '\e[32m<<<<<<<<<<<<download application service >>>>>>>>>>>>>>>\e[0m'
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>/tmp/roboshop.log
cd /app &>>/tmp/roboshop.log
unzip /tmp/catalogue.zip &>>/tmp/roboshop.log
cd /app &>>/tmp/roboshop.log
echo -e '\e[32m<<<<<<<<<<<< install dependencies >>>>>>>>>>>>>>>>\e[0m'
npm install &>>/tmp/roboshop.log
echo -e '\e[32m<<<<<<<<<<< install mongodb shell repos >>>>>>>>>>>\e[0m'
yum install mongodb-org-shell -y &>>/tmp/roboshop.log
echo -e '\e[32m<<<<<<<<<<<< load schema >>>>>>>>>>>>>>>>>\e[0m'
mongo --host mongodb.jdevops74.online </app/schema/catalogue.js &>>/tmp/roboshop.log
echo -e '\e[32m<<<<<<<<<<<<<start service >>>>>>>>>>>>>>>\e[0m'
systemctl daemon-reload &>>/tmp/roboshop.log
systemctl enable catalogue &>>/tmp/roboshop.log
systemctl restart catalogue &>>/tmp/roboshop.log