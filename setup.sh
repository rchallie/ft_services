#! /bin/bash

# Sed_set_ip :
#	[$1] : server_ip
#	[$2] : path 
sed_set_ip()
{
	sed -i.bak 's/http:\/\/IP/http:\/\/'"$1"'/g' $2
	sleep 1
}

# Mount_container :
#	[$1] : container name
mount_container()
{
	echo -ne "\033[1;32m+>\033[0;33m Build $1 image ... \n"
	docker build -t services/$1 srcs/containers/$1/ &> /dev/null
	sleep 1
}

# Up_service :
#	[$1] : service name
up_service()
{
	echo -ne "\033[1;32m+>\033[0;33m Up $1 service ... \n"
	kubectl apply -f srcs/yaml/$1.yaml &> /dev/null
	sleep 1
}

clear
echo -ne 	"\n\n\033[1;36m
███████╗████████╗     ███████╗███████╗██████╗ ██╗   ██╗██╗ ██████╗███████╗███████╗
██╔════╝╚══██╔══╝     ██╔════╝██╔════╝██╔══██╗██║   ██║██║██╔════╝██╔════╝██╔════╝
█████╗     ██║        ███████╗█████╗  ██████╔╝██║   ██║██║██║     █████╗  ███████╗
██╔══╝     ██║        ╚════██║██╔══╝  ██╔══██╗╚██╗ ██╔╝██║██║     ██╔══╝  ╚════██║
██║        ██║███████╗███████║███████╗██║  ██║ ╚████╔╝ ██║╚██████╗███████╗███████║
╚═╝        ╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚═╝ ╚═════╝╚══════╝╚══════╝
								(by rchallie)
                                                                                  \n\n"

# Brew is installed ? : 
# 	- no : Install it
# 	- yes : Check for update
which -s brew
if [[ $? != 0 ]] ; then
    echo -ne "\033[1;31m+>\033[0;33m Intall brew... \n"
    rm -rf $HOME/.brew && git clone --depth=1 https://github.com/Homebrew/brew $HOME/.brew && export PATH=$HOME/.brew/bin:$PATH && brew update && echo "export PATH=$HOME/.brew/bin:$PATH" >> ~/.zshrc &> /dev/null
else
	echo -ne "\033[1;32m+>\033[0;33m Update brew... ! \n"
    brew update &> /dev/null
fi

echo -ne "\033[1;32m+>\033[0;33m Link folder to goinfre ...\n"
export MINIKUBE_HOME=/goinfre/$USER/

echo -ne "\033[1;32m+>\033[0;33m Clean in ... \n"
rm -rf /goinfre/$USER/.minikube

if minikube &> /dev/null
then
	echo -ne "\033[1;33m+>\033[0;33m Minikube check for upgrade ... \n"
	if brew upgrade minikube &> /dev/null
	then
		echo -ne "\033[1;32m+>\033[0;33m Minikube updated ! \n"
	else
		echo -ne "\033[1;31m+>\033[0;33m Error... During minikube update. \n"
		exit 1
	fi
else
	echo -ne "\033[1;31m+>\033[0;33m Minikube installation ...\n"
	if brew install minikube &> /dev/null
	then
		echo -ne "\033[1;32m+>\033[0;33m Minikube installed ! \n"
	else
		echo -ne "\033[1;31m+>\033[0;33m Error... During minikube installation. \n"
	fi
fi

echo -ne "\033[1;32m+>\033[0;33m Start minikube (can take some minutes) ... \n"
minikube start --vm-driver=virtualbox

server_ip=`minikube ip`
sed_list="srcs/containers/mysql/wp.sql srcs/containers/wordpress/wp-config.php srcs/yaml/telegraf.yaml"

echo -ne "\033[1;32m+>\033[0;33m Set IP on configs ... \n"
for path in $sed_list
do
	sed_set_ip $server_ip $path
done

echo -ne "\033[1;32m+>\033[0;33m Update grafana db ... \n"
echo "UPDATE data_source SET url = 'http://$server_ip:8086'" | sqlite3 srcs/containers/grafana/grafana.db

echo -ne "\033[1;32m+>\033[0;33m Open ports ... \n"
minikube ssh "sudo -u root awk 'NR==14{print \"    - --service-node-port-range=1-35000\"}7' /etc/kubernetes/manifests/kube-apiserver.yaml >> tmp && sudo -u root rm /etc/kubernetes/manifests/kube-apiserver.yaml && sudo -u root mv tmp /etc/kubernetes/manifests/kube-apiserver.yaml"

echo -ne "\033[1;32m+>\033[0;33m Link docker local image to minikube ... \n"
eval $(minikube docker-env)

names="nginx influxdb grafana mysql phpmyadmin wordpress telegraf"

for name in $names
do
	mount_container $name
	up_service $name
done

echo -ne "\033[1;33m+>\033[0;33m IP : $server_ip \n"

echo -ne "\033[1;32m+>\033[0;33m Open website ... \n"
open http://$server_ip

sleep 1
sed -i.bak 's/http:\/\/'"$server_ip"'/http:\/\/IP/g' srcs/containers/mysql/wp.sql
sleep 1
sed -i.bak 's/http:\/\/'"$server_ip"'/http:\/\/IP/g' srcs/containers/wordpress/wp-config.php
sleep 1
sed -i.bak 's/http:\/\/'"$server_ip"'/http:\/\/IP/g' srcs/yaml/telegraf.yaml
sleep 1

