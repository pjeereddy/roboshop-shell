echo -e '\e[31m<<<<<<<<<<<<<<<<< create catalogue service >>>>>>>>>>>>>>>>>>>>>\e[0m'
cp catalogue.service /etc/systemd/system/catalogue.service &>>/temp/roboshop.log
echo -e '\e[31m<<<<<<<<<<<<<<<<< create mongodb repo >>>>>>>>>>>>>>>>>>>\e[0m'
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>/temp/roboshop.log
echo -e '\e[31m<<<<<<<<<<<<<<<<< download nodejs setup >>>>>>>>>>>>>>>>>>\e[0m'
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/temp/roboshop.log
echo -e '\e[31m<<<<<<<<<<<<<<<<<< install nodejs repos >>>>>>>>>>>>>>>>>>>>>>>\e[0m'
yum install nodejs -y &>>/temp/roboshop.log
echo -e '\e[31m<<<<<<< add user >>>>>>>>>>>>\e[0m'
useradd roboshop &>>/temp/roboshop.log
echo -e '\e[31m<<<<<<<<< remove directory APP >>>>>>>>>>>>>>>>\e[0m'
rm -rf /app &>>/temp/roboshop.log
echo -e '\e[31m<<<<<<<<<< create new directory APP >>>>>>>>>>>>>>\e[0m'
mkdir /app &>>/temp/roboshop.log
echo -e '\e[31m<<<<<<<<<<<<download application service >>>>>>>>>>>>>>>\e[0m'
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>/temp/roboshop.log
cd /app &>>/temp/roboshop.log
unzip /tmp/catalogue.zip &>>/temp/roboshop.log
cd /app &>>/temp/roboshop.log
echo -e '\e[31m<<<<<<<<<<<< install dependencies >>>>>>>>>>>>>>>>\e[0m'
npm install &>>/temp/roboshop.log
echo -e '\e[31m<<<<<<<<<<< install mongodb shell repos >>>>>>>>>>>\e[0m'
yum install mongodb-org-shell -y &>>/temp/roboshop.log
echo -e '\e[31m<<<<<<<<<<<< load schema >>>>>>>>>>>>>>>>>\e[0m'
mongo --host mongodb.jdevops74.online </app/schema/catalogue.js &>>/temp/roboshop.log
echo -e '\e[31m<<<<<<<<<<<<<start service >>>>>>>>>>>>>>>\e[0m'
systemctl daemon-reload &>>/temp/roboshop.log
systemctl enable catalogue &>>/temp/roboshop.log
systemctl restart catalogue &>>/temp/roboshop.log