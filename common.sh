func_exit(){
  if [ "$?" -eq "0" ]; then
  echo -e "\e[32m <<<<<<<<<<< success >>>>>>>>>> \e[0m"
 else
   echo -e "\e[31m <<<<<<<<<<< failure >>>>>>>>>> \e[0m"
   fi
}
func_prerequisite(){
 echo -e "\e[32m>>>>>>>>>>>>>>>> add user>>>>>>>>>>>>>>>> \e[0m"
   id=roboshop
   if [ $? -eq 0 ]; then
   useradd roboshop &>>${log}
   fi
   func_exit
   echo -e "\e[32m>>>>>>>>>>>>>>>> cleanup old directory >>>>>>>>>>>>>>>> \e[0m"
   func_exit
   rm -rf /app &>>${log}
   func_exit
   echo -e "\e[32m>>>>>>>>>>>>>>>> create new directory >>>>>>>>>>>>>>>> \e[0m"
   mkdir /app &>>${log}
   func_exit
   echo -e "\e[32m>>>>>>>>>>>>>>>> download application content >>>>>>>>>>>>>>>> \e[0m"
   curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}
   func_exit
   cd /app &>>${log}
   func_exit
   echo -e "\e[32m>>>>>>>>>>>>>>>> unzip application content >>>>>>>>>>>>>>>> \e[0m"
   unzip /tmp/${component}.zip &>>${log}
   func_exit

   cd /app &>>${log}
}
func_schema_setup(){
 if [ "${schema_type}" == "mongodb" ]; then
echo -e '\e[32m<<<<<<<<<<< install mongodb shell repos >>>>>>>>>>>\e[0m' | tee -a ${log}
yum install mongodb-org-shell -y &>>${log}
func_exit
echo -e '\e[32m<<<<<<<<<<<< load schema >>>>>>>>>>>>>>>>>\e[0m' | tee -a ${log}
mongo --host mongodb.jdevops74.online </app/schema/${component}.js &>>${log}
func_exit
fi

if [ "${schema_type}" == "mysql" ]; then
echo -e "\e[32m>>>>>>>>>>>>>>>> install mysql>>>>>>>>>>>>>>>> \e[0m"  | tee -a &>>/tmp/roboshop.log
  yum install mysql -y &>>${log}
  func_exit
  echo -e "\e[32m>>>>>>>>>>>>>>>> Load schema >>>>>>>>>>>>>>>> \e[0m"  | tee -a &>>/tmp/roboshop.log
  func_exit
  mysql -h mysql.jdevops74.online -uroot -pRoboShop@1 </app/schema/${component}.sql &>>${log}
  func_exit
  fi
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
func_exit
echo -e '\e[32m<<<<<<<<<<<<<<<<< create mongodb repo >>>>>>>>>>>>>>>>>>>\e[0m' | tee -a ${log}
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}
func_exit
echo -e '\e[32m<<<<<<<<<<<<<<<<< download nodejs setup >>>>>>>>>>>>>>>>>>\e[0m' | tee -a ${log}
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}
func_exit
echo -e '\e[32m<<<<<<<<<<<<<<<<<< install nodejs repos >>>>>>>>>>>>>>>>>>>>>>>\e[0m' | tee -a ${log}
yum install nodejs -y &>>${log}
func_exit
func_prerequisite
echo -e '\e[32m<<<<<<<<<<<< install dependencies >>>>>>>>>>>>>>>>\e[0m' | tee -a ${log}
npm install &>>${log}
func_exit
func_schema_setup
func_exit
echo -e '\e[32m<<<<<<<<<<<<<start service >>>>>>>>>>>>>>>\e[0m' | tee -a ${log}
func_systemd
func_exit
}


func_java(){
  log=/tmp/roboshop.log
  echo -e "\e[32m>>>>>>>>>>>>>>>> download ${component} application service >>>>>>>>>>>>>>>> \e[0m" | tee -a &>>/tmp/roboshop.log
  cp ${component}.service /etc/systemd/system/${component}.service &>>${log}
  func_exit
  echo -e "\e[32m>>>>>>>>>>>>>>>> Install maven package >>>>>>>>>>>>>>>> \e[0m"  | tee -a &>>/tmp/roboshop.log
  yum install maven -y &>>${log}
  func_exit
  func_prerequisite
  func_exit
  echo -e "\e[32m>>>>>>>>>>>>>>>> download dependencies >>>>>>>>>>>>>>>> \e[0m"  | tee -a &>>/tmp/roboshop.log
  mvn clean package &>>${log}
  func_exit
  echo -e "\e[32m <<<<<<<<<<<< relocate jar file >>>>>>>>>>\e[0m"
  mv target/${component}-1.0.jar ${component}.jar &>>${log}
  func_exit
  func_schema_setup
  func_exit
  echo -e "\e[32m>>>>>>>>>>>>>>>> load service>>>>>>>>>>>>>>>> \e[0m"
  func_systemd
  func_exit
}
func_node(){
log=/tmp/roboshop.log
echo -e "\e[32m <<<<<<<<<<<<<< Download ${component} application service <<<<<<<<<<<<\e[0m" | tee -a &>>${log}
cp ${component}.service /etc/systemd/system/${component}.service &>>$log
func_exit
echo -e "\e[32m <<<<<<<<<<<<< Download nodejs setup file >>>>>>>>>>>>> \e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$log
func_exit
echo -e "\e[32m <<<<<<<<<<<<< Install nodejs >>>>>>>>>>>\e[0m"
yum install nodejs -y &>>$log
func_exit
func_prerequisites &>>$log
func_exit
echo -e "\e[32m <<<<<<<<<<install dependencies >>>>>>>>>>>>>\e[0m"
npm install &>>$log
func_exit
echo -e "\e[32m <<<<<<<<<<<<<< start service >>>>>>>>>>>\e[0m"
func_systemd &>>$log
func_exit
}
func_payment(){
log=/tmp/roboshop.log
echo -e "\e[32m <<<<<<<<<<<<<<<<<<< copy application content >>>>>>>>>>>>>>\e[0m"
cp ${component}.service /etc/systemd/system/${component}.service &>>${log}
func_exit
echo -e "\e[32m <<<<<<<<<<<<<<<<<<< Install python >>>>>>>>>>>>>>\e[0m"
yum install python36 gcc python3-devel -y &>>${log}
func_exit
func_prerequisite
func_exit
echo -e "\e[32m <<<<<<<<<<<< install python dependencies >>>>>>>>>>>>>\e[0m"
pip3.6 install -r requirements.txt &>>${log}
func_exit
func_systemd
func_exit
}
fun_dispatch(){
  log=/tmp/roboshop.log
  echo -e "\e[32m <<<<<<<<<< Install golang >>>>>>>>>>>\e[0m"
  yum install golang -y &>>${log}
  func_exit
  func_prerequisite
  func_exit
  echo -e "\e[32m <<<<<<<<<< download dependencies >>>>>>>>>>>\e[0m"
  go mod init ${component} &>>${log}
  func_exit
  go get &>>${log}
  func_exit
  go build &>>${log}
  func_exit
  echo -e "\e[32m <<<<<<<<<<< start service >>>>>>>>>>>>> \e[0m"
 func_systemd
 func_exit
}