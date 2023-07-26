func_nodejs(){
log=/tmp/roboshop.log
echo -e '\e[32m<<<<<<<<<<<<<<<<< create ${component} service >>>>>>>>>>>>>>>>>>>>>\e[0m' | tee -a ${log}
cp ${component}.service /etc/systemd/system/${component}.service &>>${log}
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
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}
cd /app &>>${log}
unzip /tmp/${component}.zip &>>${log}
cd /app &>>${log}
echo -e '\e[32m<<<<<<<<<<<< install dependencies >>>>>>>>>>>>>>>>\e[0m' | tee -a ${log}
npm install &>>${log}
echo -e '\e[32m<<<<<<<<<<< install mongodb shell repos >>>>>>>>>>>\e[0m' | tee -a ${log}
yum install mongodb-org-shell -y &>>${log}
echo -e '\e[32m<<<<<<<<<<<< load schema >>>>>>>>>>>>>>>>>\e[0m' | tee -a ${log}
mongo --host mongodb.jdevops74.online </app/schema/${component}.js &>>${log}
echo -e '\e[32m<<<<<<<<<<<<<start service >>>>>>>>>>>>>>>\e[0m' | tee -a ${log}
systemctl daemon-reload &>>${log}
systemctl enable ${component} &>>${log}
systemctl restart ${component} &>>${log}
}