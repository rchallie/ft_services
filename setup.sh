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
if brew &> /dev/null
then
	echo -ne "\033[1;31m+> Error... Please install brew."
else
	echo -ne "\033[1;32m+>\033[0;33m Brew already installed.\n"
fi

echo -ne "\033[1;32m+>\033[0;33m Link folder to goinfre ...\n"
export MINIKUBE_HOME=/goinfre/$USER/

echo -ne "\033[1;32m+>\033[0;33m Clean in ... \n"
rm -rf /goinfre/$USER/.minikube

if minikube &> /dev/null
then
	echo -ne "\033[1;33m+>\033[0;33m Minikube check for update ... \n"
	if brew install minikube &> /dev/null
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

echo -ne "\033[1;32m+>\033[0;33m Start minikube (can take some minutes) ... \n"
minikube start --vm-driver=virtualbox

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
cp -avR srcs $MINIKUBE_HOME/.minikube/files &> /dev/null

# echo -ne "\033[1;32m+>\033[0;33m Restart minikube (can take some minutes) ... \n"
minikube start --vm-driver=virtualbox

minikube ssh 'docker build -t services/nginx /srcs/nginx/'

# nginx_ip=`minikube service nginx --url`
# echo -ne "\033[1;33m+>\033[0;33m Nginx IP : $nginx_ip \n"

# Remplacer les cmd run et expose par un .yaml Pour multi port

----------------------------

user                            www;
worker_processes                auto; # it will be determinate automatically by the number of core

error_log                       /var/log/nginx/error.log warn;
pid                             /var/run/nginx/nginx.pid; # it permit you to use /etc/init.d/nginx reload|restart|stop|start

events {
    worker_connections          1024;
}

http {
    include                     /etc/nginx/mime.types;
    default_type                application/octet-stream;
    sendfile                    on;
    access_log                  /var/log/nginx/access.log;
    keepalive_timeout           3000;
    # server {
    #     listen                  80;
    #     root                    /www;
    #     index                   index.html index.htm;
    #     server_name             localhost;
    #     client_max_body_size    32m;
    #     error_page              500 502 503 504  /50x.html;
    #     location = /50x.html {
    #           root              /var/lib/nginx/html;
    #     }
    # }

    server {
        listen 80;
        listen [::]:80;

        server_name www;

        root /www;
        index index.html;

        location / {
            autoindex on;
            try_files $uri $uri/ =404;
        }
    }

    server{

        listen 443 ssl ;
        listen [::]:443 ssl ;

        server_name www;

        ssl_certificate /etc/nginx/ssl/www.pem;
        ssl_certificate_key /etc/nginx/ssl/www.key;

        root /www;
        index index.html;

        location / {
            autoindex on;
            try_files $uri $uri/ =404;
        }
    }
}

------------------------------------

apiVersion: v1
kind: Service
metadata:
  name: nginx-svc
  labels:
    app: myapp
spec:
  type: NodePort
  ports:
  - port: 80
    protocol: TCP
    name: http
  - port: 443
    protocol: TCP
    name: https
  selector:
    app: myapp
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: myapp
spec:
  replicas: 1
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
      - name: nginx
        image: services/nginx
        ports:
        - containerPort: 80
        - containerPort: 443
        imagePullPolicy: Never
---
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: nginx-ingress
  annotations:
    kubernetes.io/ingress.class: nginx
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
  namespace: default
spec:
  rules:
  - host: ftservices.rchallie
  - http:
      paths:
      - path: /
        backend:
          serviceName: nginx-svc
          servicePort: 80

-----------------------------------------------------------------

FROM alpine:latest

# update && install nginx && bash && openssl && folder for nginx pid
RUN apk update && apk add nginx \
&& apk add --no-cache --upgrade bash \
&& apk add openssl && mkdir -p var/run/nginx

# create user for nginx && generate nginx folder && add permissions
RUN adduser -D -g 'www' www \
&& mkdir /www && chown -R www:www /var/lib/nginx \
&& chown -R www:www /www

# SSL
RUN mkdir /etc/nginx/ssl \
&& openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out /etc/nginx/ssl/www.pem -keyout /etc/nginx/ssl/www.key -subj "/C=FR/ST=Paris/L=Paris/O=42 School/OU=rchallie/CN=ft_services"

# Nginx config
RUN rm /etc/nginx/nginx.conf
COPY ./nginx.conf /etc/nginx/nginx.conf

# Start nginx
CMD [ "nginx" , "-g", "daemon off;" ]
