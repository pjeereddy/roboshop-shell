cp mongo.repo /etc/yum.repos.d/mongo.repo
yum install mongodb-org -y
#update listen address
systemctl enable mongod
systemctl restart mongod