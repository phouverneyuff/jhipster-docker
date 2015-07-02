#!/bin/bash

echo "Efetuando o download do docker do JHipster ..."
sudo docker pull jdubois/jhipster-docker:latest

echo "Efetuando o download do docker do MySQL ..."
sudo docker pull mysql/mysql-server:latest

MYSQL_DATABASE=pedido
MYSQL_ROOT_PASSWORD=rootpwd
MYSQL_USER=pedido
MYSQL_PASSWORD=pedidopwd

MYSQL_VAR=mysql-var
VOLUME_MYSQL_VAR=`pwd`/$MYSQL_VAR

VOLUME_JHIPSTER=$1

if [ ! -d $MYSQL_VAR ]; then
	mkdir $MYSQL_VAR
	echo "Criando a pasta $MYSQL_VAR em `pwd` para armazenar os dados persistentes do MySQL"
fi

echo ""
echo "###################################################################################################"

echo "Volume compartilhado do MySQL: $VOLUME_MYSQL_VAR"

echo "Database: $MYSQL_DATABASE"
echo "Usuário admin e senha: root:$MYSQL_ROOT_PASSWORD"
echo "Usuário e senha padrões: $MYSQL_USER:$MYSQL_PASSWORD"

echo "Service Name to Mysql: 'mysql'"

echo "###################################################################################################"
echo ""

echo "Iniciando pela primeira vez o serviço do MySQL. Para iniciar da proxima vez: 'docker start mysql'"
sudo docker rm -f mysql
sudo docker run -v $VOLUME_MYSQL_VAR:/var/lib/mysql -P -e MYSQL_DATABASE=$MYSQL_DATABASE -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD -e MYSQL_USER=$MYSQL_USER -e MYSQL_PASSWORD=$MYSQL_PASSWORD -d --name mysql mysql/mysql-server

echo ""
echo "###################################################################################################"

echo "Volume compartilhado do JHipster: $VOLUME_JHIPSTER"

echo "###################################################################################################"
echo ""

echo "Iniciando pela primeira vez o serviço do JHipster. Para iniciar da proxima vez: 'docker start jhipster'" 
sudo docker rm -f jhipster
sudo docker run --name jhipster --link mysql:mysql -v $VOLUME_JHIPSTER:/jhipster -p 8081:8080 -p 3000:3000 -p 3001:3000 -p 4022:22 -d -t -i jdubois/jhipster-docker /bin/bash

echo ""
echo "Parando o docker do jhipster ..."
sudo docker stop jhipster

echo "Parando o docker mysql ..."
sudo docker stop mysql
