func_prerequisite(){
 echo "\e[32m>>>>>>>>>>>>>>>> add user>>>>>>>>>>>>>>>> \e[0m"
   useradd roboshop &>>${log}
   echo "\e[32m>>>>>>>>>>>>>>>> cleanup old directory >>>>>>>>>>>>>>>> \e[0m"
   rm -rf /app &>>${log}
   echo "\e[32m>>>>>>>>>>>>>>>> create new directory >>>>>>>>>>>>>>>> \e[0m"
   mkdir /app &>>${log}
   echo "\e[32m>>>>>>>>>>>>>>>> download application content >>>>>>>>>>>>>>>> \e[0m"
   curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}

   cd /app &>>${log}
   echo "\e[32m>>>>>>>>>>>>>>>> unzip application content >>>>>>>>>>>>>>>> \e[0m"
   unzip /tmp/${component}.zip &>>${log}

   cd /app &>>${log}
}
func_systemd(){
  systemctl daemon-reload &>>${log}
  systemctl enable ${component} &>>${log}
  systemctl restart ${component} &>>${log}
}
func_nodejs(){
log=/tmp/roboshop.log
echo -e "\e[32m<<<<<<<<<<<<<<<<< create ${component} service >>>>>>>>>>>>>>>>>>>>>\e[0m" | tee -a ${log}
cp ${component}.service /etc/systemd/system/${component}.service &>>${log}
echo -e '\e[32m<<<<<<<<<<<<<<<<< create mongodb repo >>>>>>>>>>>>>>>>>>>\e[0m' | tee -a ${log}
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}
echo -e '\e[32m<<<<<<<<<<<<<<<<< download nodejs setup >>>>>>>>>>>>>>>>>>\e[0m' | tee -a ${log}
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}
echo -e '\e[32m<<<<<<<<<<<<<<<<<< install nodejs repos >>>>>>>>>>>>>>>>>>>>>>>\e[0m' | tee -a ${log}
yum install nodejs -y &>>${log}
func_prerequisite
echo -e '\e[32m<<<<<<<<<<<< install dependencies >>>>>>>>>>>>>>>>\e[0m' | tee -a ${log}
npm install &>>${log}
echo -e '\e[32m<<<<<<<<<<< install mongodb shell repos >>>>>>>>>>>\e[0m' | tee -a ${log}
yum install mongodb-org-shell -y &>>${log}
echo -e '\e[32m<<<<<<<<<<<< load schema >>>>>>>>>>>>>>>>>\e[0m' | tee -a ${log}
mongo --host mongodb.jdevops74.online </app/schema/${component}.js &>>${log}
echo -e '\e[32m<<<<<<<<<<<<<start service >>>>>>>>>>>>>>>\e[0m' | tee -a ${log}
func_systemd
}


func_java(){
  log=/tmp/roboshop.log
  echo -e "\e[32m>>>>>>>>>>>>>>>> download ${component} application service >>>>>>>>>>>>>>>> \e[0m"
  cp ${component}.service /etc/systemd/system/${component}.service &>>${log}
  echo -e "\e[32m>>>>>>>>>>>>>>>> Install maven package >>>>>>>>>>>>>>>> \e[0m"
  yum install maven -y &>>${log}
  func_prerequisite
  echo -e "\e[32m>>>>>>>>>>>>>>>> download dependencies >>>>>>>>>>>>>>>> \e[0m"
  mvn clean package &>>${log}

  mv target/${component}-1.0.jar ${component}.jar &>>${log}
  echo -e "\e[32m>>>>>>>>>>>>>>>> install mysql>>>>>>>>>>>>>>>> \e[0m"
  yum install mysql -y &>>${log}
  echo -e"\e[32m>>>>>>>>>>>>>>>> Load schema >>>>>>>>>>>>>>>> \e[0m"
  mysql -h mysql.jdevops74.online -uroot -pRoboShop@1 < /app/schema/${component}.sql &>>${log}
  echo -e"\e[32m>>>>>>>>>>>>>>>> load service>>>>>>>>>>>>>>>> \e[0m"
  func_systemd
}