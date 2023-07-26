log=/tmp/roboshop.log
echo -e '\e[32m<<<<<<<<<<<<<<<<< create catalogue service >>>>>>>>>>>>>>>>>>>>>\e[0m' | tee -a ${log}
cp catalogue.service /etc/systemd/system/catalogue.service &>>${log}
echo -e '\e[32m<<<<<<<<<<<<<<<<< create mongodb repo >>>>>>>>>>>>>>>>>>>\e[0m' | tee -a ${log}
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}
echo -e '\e[32m<<<<<<<<<<<<<<<<< download nodejs setup >>>>>>>>>>>>>>>>>>\e[0m' | tee -a ${log}
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}
echo -e '\e[32m<<<<<<<<<<<<<<<<<< install nodejs repos >>>>>>>>>>>>>>>>>>>>>>>\e[0m' | tee -a ${log}
yum install nodejs -y &>>${log}
echo -e '\e[32m<<<<<<< add user >>>>>>>>>>>>\e[0m' | tee -a ${log}
useradd roboshop &>>${log}
echo -e '\e[32m<<<<<<<<< remove directory APP >>>>>>>>>>>>>>>>\e[0m' | tee -a ${log} | tee -a ${log}
rm -rf /app &>>${log}
echo -e '\e[32m<<<<<<<<<< create new directory APP >>>>>>>>>>>>>>\e[0m' | tee -a ${log}
mkdir /app &>>${log}
echo -e '\e[32m<<<<<<<<<<<<download application service >>>>>>>>>>>>>>>\e[0m' | tee -a ${log}
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log}
cd /app &>>${log}
unzip /tmp/catalogue.zip &>>${log}
cd /app &>>${log}
echo -e '\e[32m<<<<<<<<<<<< install dependencies >>>>>>>>>>>>>>>>\e[0m' | tee -a ${log}
npm install &>>${log}
echo -e '\e[32m<<<<<<<<<<< install mongodb shell repos >>>>>>>>>>>\e[0m' | tee -a ${log}
yum install mongodb-org-shell -y &>>${log}
echo -e '\e[32m<<<<<<<<<<<< load schema >>>>>>>>>>>>>>>>>\e[0m' | tee -a ${log}
mongo --host mongodb.jdevops74.online </app/schema/catalogue.js &>>${log}
echo -e '\e[32m<<<<<<<<<<<<<start service >>>>>>>>>>>>>>>\e[0m' | tee -a ${log}
systemctl daemon-reload &>>${log}
systemctl enable catalogue &>>${log}
systemctl restart catalogue &>>${log}