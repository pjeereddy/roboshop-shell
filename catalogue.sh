echo -e '\e[31m<<<<<<<<<<<<<<<<< create catalogue service >>>>>>>>>>>>>>>>>>>>>\e[0m'
cp catalogue.service /etc/systemd/system/catalogue.service
echo -e '\e[31m<<<<<<<<<<<<<<<<< create mongodb repo >>>>>>>>>>>>>>>>>>>\e[0m'
cp mongo.repo /etc/yum.repos.d/mongo.repo
echo -e '\e[31m<<<<<<<<<<<<<<<<< download nodejs setup >>>>>>>>>>>>>>>>>>\e[0m'
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
echo -e '\e[31m<<<<<<<<<<<<<<<<<< install nodejs repos >>>>>>>>>>>>>>>>>>>>>>>\e[0m'
yum install nodejs -y
echo -e '\e[31m<<<<<<< add user >>>>>>>>>>>>\e[0m'
useradd roboshop
echo -e '\e[31m<<<<<<<<< remove directory APP >>>>>>>>>>>>>>>>\e[0m'
rm -rf /app
echo -e '\e[31m<<<<<<<<<< create new directory APP >>>>>>>>>>>>>>\e[0m'
mkdir /app
echo -e '\e[31m<<<<<<<<<<<<download application service >>>>>>>>>>>>>>>\e[0m'
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app
unzip /tmp/catalogue.zip
cd /app
echo -e '\e[31m<<<<<<<<<<<< install dependencies >>>>>>>>>>>>>>>>\e[0m'
npm install
echo -e '\e[31m<<<<<<<<<<< install mongodb shell repos >>>>>>>>>>>\e[0m'
yum install mongodb-org-shell -y
echo -e '\e[31m<<<<<<<<<<<< load schema >>>>>>>>>>>>>>>>>\e[0m'
mongo --host mongodb.jdevops74.online </app/schema/catalogue.js
echo -e '\e[31m<<<<<<<<<<<<<start service >>>>>>>>>>>>>>>\e[0m'
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue