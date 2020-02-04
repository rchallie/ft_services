#! /bin/bash
clear
echo -ne 	"\n\n\033[1;36m
███████╗████████╗     ███████╗███████╗██████╗ ██╗   ██╗██╗ ██████╗███████╗███████╗
██╔════╝╚══██╔══╝     ██╔════╝██╔════╝██╔══██╗██║   ██║██║██╔════╝██╔════╝██╔════╝
█████╗     ██║        ███████╗█████╗  ██████╔╝██║   ██║██║██║     █████╗  ███████╗
██╔══╝     ██║        ╚════██║██╔══╝  ██╔══██╗╚██╗ ██╔╝██║██║     ██╔══╝  ╚════██║
██║        ██║███████╗███████║███████╗██║  ██║ ╚████╔╝ ██║╚██████╗███████╗███████║
╚═╝        ╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚═╝ ╚═════╝╚══════╝╚══════╝
                                                                                  \n\n"
which -s brew
if [[ $? != 0 ]] ; then
    echo -ne "\033[1;31m+>\033[0;33m Intall brew... \n"
    rm -rf $HOME/.brew && git clone --depth=1 https://github.com/Homebrew/brew $HOME/.brew && export PATH=$HOME/.brew/bin:$PATH && brew update && echo "export PATH=$HOME/.brew/bin:$PATH" >> ~/.zshrc &> /dev/null
else
	echo -ne "\033[1;32m+>\033[0;33m Update brew... ! \n"
    brew update
fi

echo -ne "\033[1;32m+>\033[0;33m Link folder to goinfre ...\n"
export MINIKUBE_HOME=/goinfre/$USER/

echo -ne "\033[1;32m+>\033[0;33m Clean in ... \n"
rm -rf /goinfre/$USER/.minikube

if minikube &> /dev/null
then
	echo -ne "\033[1;33m+>\033[0;33m Minikube check for update ... \n"
	if brew install minikube
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

# cp research.md $MINIKUBE_HOME/.minikube/files
echo -ne "\033[1;33m+>\033[0;33m Enable addons ...\n"
minikube addons enable ingress 

# echo -ne "\033[1;32m+>\033[0;33m Start minikube (can take some minutes) ... \n"
minikube start --vm-driver=virtualbox --extra-config=apiserver.service-node-port-range=1-35000

# echo -ne "\033[1;35m+>\033[0;33m Docker : NGINX :\n"
# echo -ne "\033[1;33m+>\033[0;33m Build image ...\n"
# cd ./srcs/nginx/
# docker build -t services/nginxcustom . &> /dev/null
# cd ../../..

# echo -ne "\033[1;33m+>\033[0;33m Run image on minikube ...\n"
# kubectl run nginx --image=nginx_custom --port=80 &> /dev/null
# kubectl expose deployment nginx_custom --target-port=80 --type=NodePort &> /dev/null

# nginx_ip=`minikube service nginx --url`
# echo -ne "\033[1;33m+>\033[0;33m Nginx IP : $nginx_ip \n"


echo -ne "\033[1;32m+>\033[0;33m Stop minikube ... \n"
minikube stop

echo -ne "\033[1;32m+>\033[0;33m Copy utils files ... \n"
cp -avR srcs/containers $MINIKUBE_HOME/.minikube/files/srcs &> /dev/null

# echo -ne "\033[1;32m+>\033[0;33m Restart minikube (can take some minutes) ... \n"
minikube start --vm-driver=virtualbox --extra-config=apiserver.service-node-port-range=1-35000

minikube ssh 'docker build -t services/nginx /srcs/nginx/'
minikube ssh 'docker build -t services/influxdb /srcs/influxdb/'
minikube ssh 'docker build -t services/grafana /srcs/grafana/'
minikube ssh 'docker build -t services/mysql /srcs/mysql/'

kubectl apply -f srcs/yaml/nginx.yaml
kubectl apply -f srcs/yaml/influxdb.yaml
kubectl apply -f srcs/yaml/grafana.yaml
kubectl apply -f srcs/yaml/mysql.yaml

server_ip=`minikube ip`
echo -ne "\033[1;33m+>\033[0;33m IP : $server_ip \n"

echo -ne "\033[1;32m+>\033[0;33m Open website ... \n"
open http://$server_ip
# Remplacer les cmd run et expose par un .yaml Pour multi port
