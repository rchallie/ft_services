    > minikube-v1.6.0.iso: 150.93 MiB / 150.93 MiB [-] 100.00% 88.40 MiB p/s 2s
🔥  Creating virtualbox VM (CPUs=2, Memory=2000MB, Disk=20000MB) ...
🐳  Preparing Kubernetes v1.17.0 on Docker '19.03.5' ...
💾  Downloading kubelet v1.17.0
💾  Downloading kubeadm v1.17.0
🚜  Pulling images ...
🚀  Launching Kubernetes ...
⌛  Waiting for cluster to come online ...
🏄  Done! kubectl is now configured to use "minikube"
+> Stop minikube ...
✋  Stopping "minikube" in virtualbox ...
🛑  "minikube" stopped.
+> Copy utils files ...
😄  minikube v1.6.2 on Darwin 10.14.5
    ▪ MINIKUBE_HOME=/goinfre/rchallie/
✨  Selecting 'virtualbox' driver from user configuration (alternates: [hyperkit vmwarefusion])
💡  Tip: Use 'minikube start -p <name>' to create a new cluster, or 'minikube delete' to delete this one.
🔄  Starting existing virtualbox VM for "minikube" ...
⌛  Waiting for the host to be provisioned ...
🐳  Preparing Kubernetes v1.17.0 on Docker '19.03.5' ...
🚀  Launching Kubernetes ...
🏄  Done! kubectl is now configured to use "minikube"
Sending build context to Docker daemon  4.608kB
Step 1/9 : FROM alpine:latest
latest: Pulling from library/alpine
c9b1b535fdd9: Pull complete
Digest: sha256:ab00606a42621fb68f2ed6ad3c88be54397f981a7b70a79db3d1172b11c4367d
Status: Downloaded newer image for alpine:latest
 ---> e7d92cdc71fe
Step 2/9 : EXPOSE 80:80
 ---> Running in bb9185948375
Removing intermediate container bb9185948375
 ---> 99d454c96a77
Step 3/9 : EXPOSE 443:443
 ---> Running in 809959a93627
Removing intermediate container 809959a93627
 ---> 173280182801
Step 4/9 : RUN apk update && apk add nginx && apk add --no-cache --upgrade bash && apk add openssl && mkdir -p var/run/nginx
 ---> Running in 4c4eb13bbc6a
fetch http://dl-cdn.alpinelinux.org/alpine/v3.11/main/x86_64/APKINDEX.tar.gz
fetch http://dl-cdn.alpinelinux.org/alpine/v3.11/community/x86_64/APKINDEX.tar.gz
v3.11.3-28-g97c87447df [http://dl-cdn.alpinelinux.org/alpine/v3.11/main]
v3.11.3-30-g2d9c1a116c [http://dl-cdn.alpinelinux.org/alpine/v3.11/community]
OK: 11258 distinct packages available
(1/2) Installing pcre (8.43-r0)
(2/2) Installing nginx (1.16.1-r6)
Executing nginx-1.16.1-r6.pre-install
Executing busybox-1.31.1-r9.trigger
OK: 7 MiB in 16 packages
fetch http://dl-cdn.alpinelinux.org/alpine/v3.11/main/x86_64/APKINDEX.tar.gz
fetch http://dl-cdn.alpinelinux.org/alpine/v3.11/community/x86_64/APKINDEX.tar.gz
(1/5) Installing ncurses-terminfo-base (6.1_p20191130-r0)
(2/5) Installing ncurses-terminfo (6.1_p20191130-r0)
(3/5) Installing ncurses-libs (6.1_p20191130-r0)
(4/5) Installing readline (8.0.1-r0)
(5/5) Installing bash (5.0.11-r1)
Executing bash-5.0.11-r1.post-install
Executing busybox-1.31.1-r9.trigger
OK: 16 MiB in 21 packages
(1/1) Installing openssl (1.1.1d-r3)
Executing busybox-1.31.1-r9.trigger
OK: 17 MiB in 22 packages
Removing intermediate container 4c4eb13bbc6a
 ---> 7c10c5c56190
Step 5/9 : RUN adduser -D -g 'www' www && mkdir /www && chown -R www:www /var/lib/nginx && chown -R www:www /www
 ---> Running in 0478b477cb54
Removing intermediate container 0478b477cb54
 ---> 92e215cd63e4
Step 6/9 : RUN mkdir /etc/nginx/ssl && openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out /etc/nginx/ssl/www.pem -keyout /etc/nginx/ssl/www.key -subj "/C=FR/ST=Paris/L=Paris/O=42 School/OU=rchallie/CN=ft_services"
 ---> Running in 1aba200ccbe7
Generating a RSA private key
................................++++
................................................................................................++++
writing new private key to '/etc/nginx/ssl/www.key'
-----
Removing intermediate container 1aba200ccbe7
 ---> db7434b8b8e2
Step 7/9 : RUN rm /etc/nginx/nginx.conf
 ---> Running in 5a7dda7c3ef8
Removing intermediate container 5a7dda7c3ef8
 ---> faaec5f3f6e9
Step 8/9 : COPY ./nginx.conf /etc/nginx/nginx.conf
 ---> 8b0bd36f9b4b
Step 9/9 : CMD [ "nginx" , "-g", "daemon off;" ]
 ---> Running in 4f1746db773d
Removing intermediate container 4f1746db773d
 ---> 7aa271aeef45
Successfully built 7aa271aeef45
Successfully tagged services/nginx:latest
➜  ft_services git:(master) ✗ kubectl apply -f ./ingress.yaml
service/nginx created
deployment.apps/nginx-deployment created
ingress.networking.k8s.io/example-ingress created
➜  ft_services git:(master) ✗ kubectl get ingress
NAME              HOSTS              ADDRESS          PORTS   AGE
example-ingress   hello-world.info   192.168.99.142   80      76s
➜  ft_services git:(master) ✗ curl 192.168.99.142
<html>
<head><title>404 Not Found</title></head>
<body>
<center><h1>404 Not Found</h1></center>
<hr><center>openresty/1.15.8.2</center>
</body>
</html>
➜  ft_services git:(master) ✗ kubectl get services
NAME         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                      AGE
kubernetes   ClusterIP   10.96.0.1       <none>        443/TCP                      6m11s
nginx        NodePort    10.96.180.142   <none>        80:32034/TCP,443:32190/TCP   2m51s
➜  ft_services git:(master) ✗ minikube ip
192.168.99.142
➜  ft_services git:(master) ✗ minikube service nginx --url
http://192.168.99.142:31636
http://192.168.99.142:30656
➜  ft_services git:(master) ✗ minikube dashboard
➜  ft_services git:(master) ✗ ./setup.sh



███████╗████████╗     ███████╗███████╗██████╗ ██╗   ██╗██╗ ██████╗███████╗███████╗
██╔════╝╚══██╔══╝     ██╔════╝██╔════╝██╔══██╗██║   ██║██║██╔════╝██╔════╝██╔════╝
█████╗     ██║        ███████╗█████╗  ██████╔╝██║   ██║██║██║     █████╗  ███████╗
██╔══╝     ██║        ╚════██║██╔══╝  ██╔══██╗╚██╗ ██╔╝██║██║     ██╔══╝  ╚════██║
██║        ██║███████╗███████║███████╗██║  ██║ ╚████╔╝ ██║╚██████╗███████╗███████║
╚═╝        ╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚═╝ ╚═════╝╚══════╝╚══════╝


+> Brew already installed.
+> Link folder to goinfre ...
+> Clean in ...
+> Minikube check for update ...
+> Minikube updated !
+> Enable addons ...
✅  ingress was successfully enabled
+> Start minikube (can take some minutes) ...
😄  minikube v1.6.2 on Darwin 10.14.5
    ▪ MINIKUBE_HOME=/goinfre/rchallie/
✨  Selecting 'virtualbox' driver from user configuration (alternates: [hyperkit vmwarefusion])
💿  Downloading VM boot image ...
    > minikube-v1.6.0.iso.sha256: 65 B / 65 B [--------------] 100.00% ? p/s 0s
    > minikube-v1.6.0.iso: 150.93 MiB / 150.93 MiB [-] 100.00% 86.97 MiB p/s 2s
🔥  Creating virtualbox VM (CPUs=2, Memory=2000MB, Disk=20000MB) ...
🐳  Preparing Kubernetes v1.17.0 on Docker '19.03.5' ...
💾  Downloading kubelet v1.17.0
💾  Downloading kubeadm v1.17.0
🚜  Pulling images ...
🚀  Launching Kubernetes ...
⌛  Waiting for cluster to come online ...
🏄  Done! kubectl is now configured to use "minikube"
+> Stop minikube ...
✋  Stopping "minikube" in virtualbox ...
🛑  "minikube" stopped.
+> Copy utils files ...
😄  minikube v1.6.2 on Darwin 10.14.5
    ▪ MINIKUBE_HOME=/goinfre/rchallie/
✨  Selecting 'virtualbox' driver from user configuration (alternates: [hyperkit vmwarefusion])
💡  Tip: Use 'minikube start -p <name>' to create a new cluster, or 'minikube delete' to delete this one.
🔄  Starting existing virtualbox VM for "minikube" ...
⌛  Waiting for the host to be provisioned ...
🐳  Preparing Kubernetes v1.17.0 on Docker '19.03.5' ...
🚀  Launching Kubernetes ...
🏄  Done! kubectl is now configured to use "minikube"
Sending build context to Docker daemon  4.608kB
Step 1/7 : FROM alpine:latest
latest: Pulling from library/alpine
c9b1b535fdd9: Pull complete
Digest: sha256:ab00606a42621fb68f2ed6ad3c88be54397f981a7b70a79db3d1172b11c4367d
Status: Downloaded newer image for alpine:latest
 ---> e7d92cdc71fe
Step 2/7 : RUN apk update && apk add nginx && apk add --no-cache --upgrade bash && apk add openssl && mkdir -p var/run/nginx
 ---> Running in 63a09b92caed
fetch http://dl-cdn.alpinelinux.org/alpine/v3.11/main/x86_64/APKINDEX.tar.gz
fetch http://dl-cdn.alpinelinux.org/alpine/v3.11/community/x86_64/APKINDEX.tar.gz
v3.11.3-28-g97c87447df [http://dl-cdn.alpinelinux.org/alpine/v3.11/main]
v3.11.3-30-g2d9c1a116c [http://dl-cdn.alpinelinux.org/alpine/v3.11/community]
OK: 11258 distinct packages available
(1/2) Installing pcre (8.43-r0)
(2/2) Installing nginx (1.16.1-r6)
Executing nginx-1.16.1-r6.pre-install
Executing busybox-1.31.1-r9.trigger
OK: 7 MiB in 16 packages
fetch http://dl-cdn.alpinelinux.org/alpine/v3.11/main/x86_64/APKINDEX.tar.gz
fetch http://dl-cdn.alpinelinux.org/alpine/v3.11/community/x86_64/APKINDEX.tar.gz
(1/5) Installing ncurses-terminfo-base (6.1_p20191130-r0)
(2/5) Installing ncurses-terminfo (6.1_p20191130-r0)
(3/5) Installing ncurses-libs (6.1_p20191130-r0)
(4/5) Installing readline (8.0.1-r0)
(5/5) Installing bash (5.0.11-r1)
Executing bash-5.0.11-r1.post-install
Executing busybox-1.31.1-r9.trigger
OK: 16 MiB in 21 packages
(1/1) Installing openssl (1.1.1d-r3)
Executing busybox-1.31.1-r9.trigger
OK: 17 MiB in 22 packages
Removing intermediate container 63a09b92caed
 ---> 4a2f7d6ecad9
Step 3/7 : RUN adduser -D -g 'www' www && mkdir /www && chown -R www:www /var/lib/nginx && chown -R www:www /www
 ---> Running in a036b833b8a7
Removing intermediate container a036b833b8a7
 ---> fed6d76e2425
Step 4/7 : RUN mkdir /etc/nginx/ssl && openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out /etc/nginx/ssl/www.pem -keyout /etc/nginx/ssl/www.key -subj "/C=FR/ST=Paris/L=Paris/O=42 School/OU=rchallie/CN=ft_services"
 ---> Running in c2448fabdfff
Generating a RSA private key
..........................................++++
.................................................................................................................................................................................................................................++++
writing new private key to '/etc/nginx/ssl/www.key'
-----
Removing intermediate container c2448fabdfff
 ---> 020b80383163
Step 5/7 : RUN rm /etc/nginx/nginx.conf
 ---> Running in 881e6579f5fd
Removing intermediate container 881e6579f5fd
 ---> 450f3e154158
Step 6/7 : COPY ./nginx.conf /etc/nginx/nginx.conf
 ---> 7a7b5420f4ef
Step 7/7 : CMD [ "nginx" , "-g", "daemon off;" ]
 ---> Running in 73d1b241601f
Removing intermediate container 73d1b241601f
 ---> 0b929647ae09
Successfully built 0b929647ae09
Successfully tagged services/nginx:latest
➜  ft_services git:(master) ✗ docker stop test
docker test
➜  ft_services git:(master) ✗ docker rm test
test
➜  ft_services git:(master) ✗ minikube stop
✋  Stopping "minikube" in virtualbox ...
🛑  "minikube" stopped.
➜  ft_services git:(master) ✗ minikube delete
🔥  Deleting "minikube" in virtualbox ...
💔  The "minikube" cluster has been deleted.
🔥  Successfully deleted profile "minikube"
➜  ft_services git:(master) ✗ ./setup.sh



███████╗████████╗     ███████╗███████╗██████╗ ██╗   ██╗██╗ ██████╗███████╗███████╗
██╔════╝╚══██╔══╝     ██╔════╝██╔════╝██╔══██╗██║   ██║██║██╔════╝██╔════╝██╔════╝
█████╗     ██║        ███████╗█████╗  ██████╔╝██║   ██║██║██║     █████╗  ███████╗
██╔══╝     ██║        ╚════██║██╔══╝  ██╔══██╗╚██╗ ██╔╝██║██║     ██╔══╝  ╚════██║
██║        ██║███████╗███████║███████╗██║  ██║ ╚████╔╝ ██║╚██████╗███████╗███████║
╚═╝        ╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚═╝ ╚═════╝╚══════╝╚══════╝


+> Brew already installed.
+> Link folder to goinfre ...
+> Clean in ...
+> Minikube check for update ...
+> Minikube updated !
+> Enable addons ...
✅  ingress was successfully enabled
+> Start minikube (can take some minutes) ...
😄  minikube v1.6.2 on Darwin 10.14.5
    ▪ MINIKUBE_HOME=/goinfre/rchallie/
✨  Selecting 'virtualbox' driver from user configuration (alternates: [hyperkit vmwarefusion])
💿  Downloading VM boot image ...
    > minikube-v1.6.0.iso.sha256: 65 B / 65 B [--------------] 100.00% ? p/s 0s
    > minikube-v1.6.0.iso: 150.93 MiB / 150.93 MiB [-] 100.00% 32.66 MiB p/s 5s
🔥  Creating virtualbox VM (CPUs=2, Memory=2000MB, Disk=20000MB) ...
🐳  Preparing Kubernetes v1.17.0 on Docker '19.03.5' ...
💾  Downloading kubelet v1.17.0
💾  Downloading kubeadm v1.17.0
🚜  Pulling images ...
🚀  Launching Kubernetes ...
⌛  Waiting for cluster to come online ...
🏄  Done! kubectl is now configured to use "minikube"
+> Stop minikube ...
✋  Stopping "minikube" in virtualbox ...
🛑  "minikube" stopped.
+> Copy utils files ...
😄  minikube v1.6.2 on Darwin 10.14.5
    ▪ MINIKUBE_HOME=/goinfre/rchallie/
✨  Selecting 'virtualbox' driver from user configuration (alternates: [hyperkit vmwarefusion])
💡  Tip: Use 'minikube start -p <name>' to create a new cluster, or 'minikube delete' to delete this one.
🔄  Starting existing virtualbox VM for "minikube" ...
⌛  Waiting for the host to be provisioned ...
🐳  Preparing Kubernetes v1.17.0 on Docker '19.03.5' ...
🚀  Launching Kubernetes ...
🏄  Done! kubectl is now configured to use "minikube"
Sending build context to Docker daemon   5.12kB
Step 1/7 : FROM alpine:latest
latest: Pulling from library/alpine
c9b1b535fdd9: Pull complete
Digest: sha256:ab00606a42621fb68f2ed6ad3c88be54397f981a7b70a79db3d1172b11c4367d
Status: Downloaded newer image for alpine:latest
 ---> e7d92cdc71fe
Step 2/7 : RUN apk update && apk add nginx && apk add --no-cache --upgrade bash && apk add openssl && mkdir -p var/run/nginx
 ---> Running in 92c04ee40950
fetch http://dl-cdn.alpinelinux.org/alpine/v3.11/main/x86_64/APKINDEX.tar.gz
fetch http://dl-cdn.alpinelinux.org/alpine/v3.11/community/x86_64/APKINDEX.tar.gz
v3.11.3-28-g97c87447df [http://dl-cdn.alpinelinux.org/alpine/v3.11/main]
v3.11.3-30-g2d9c1a116c [http://dl-cdn.alpinelinux.org/alpine/v3.11/community]
OK: 11258 distinct packages available
(1/2) Installing pcre (8.43-r0)
(2/2) Installing nginx (1.16.1-r6)
Executing nginx-1.16.1-r6.pre-install
Executing busybox-1.31.1-r9.trigger
OK: 7 MiB in 16 packages
fetch http://dl-cdn.alpinelinux.org/alpine/v3.11/main/x86_64/APKINDEX.tar.gz
fetch http://dl-cdn.alpinelinux.org/alpine/v3.11/community/x86_64/APKINDEX.tar.gz
(1/5) Installing ncurses-terminfo-base (6.1_p20191130-r0)
(2/5) Installing ncurses-terminfo (6.1_p20191130-r0)
(3/5) Installing ncurses-libs (6.1_p20191130-r0)
(4/5) Installing readline (8.0.1-r0)
(5/5) Installing bash (5.0.11-r1)
Executing bash-5.0.11-r1.post-install
Executing busybox-1.31.1-r9.trigger
OK: 16 MiB in 21 packages
(1/1) Installing openssl (1.1.1d-r3)
Executing busybox-1.31.1-r9.trigger
OK: 17 MiB in 22 packages
Removing intermediate container 92c04ee40950
 ---> fc07cae4eeb5
Step 3/7 : RUN adduser -D -g 'www' www && mkdir /www && chown -R www:www /var/lib/nginx && chown -R www:www /www
 ---> Running in b91ecdf5c510
Removing intermediate container b91ecdf5c510
 ---> 5de7f53ecfac
Step 4/7 : RUN mkdir /etc/nginx/ssl && openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out /etc/nginx/ssl/www.pem -keyout /etc/nginx/ssl/www.key -subj "/C=FR/ST=Paris/L=Paris/O=42 School/OU=rchallie/CN=ft_services"
 ---> Running in 7900ffb1c181
Generating a RSA private key
....................................................++++
.........................++++
writing new private key to '/etc/nginx/ssl/www.key'
-----
Removing intermediate container 7900ffb1c181
 ---> cbd120a32f58
Step 5/7 : RUN rm /etc/nginx/nginx.conf
 ---> Running in bafcd36267a8
Removing intermediate container bafcd36267a8
 ---> 4b7a29f5fa7b
Step 6/7 : COPY ./nginx.conf /etc/nginx/nginx.conf
 ---> a8e2a66c8fd4
Step 7/7 : CMD [ "nginx" , "-g", "daemon off;" ]
 ---> Running in 58874734c7b1
Removing intermediate container 58874734c7b1
 ---> d5081a2f4dd0
Successfully built d5081a2f4dd0
Successfully tagged services/nginx:latest
➜  ft_services git:(master) ✗ kubectl apply -f ./ingress.yaml
service/nginx created
deployment.apps/nginx-deployment created
ingress.networking.k8s.io/example-ingress created
➜  ft_services git:(master) ✗ minikube ssh
                         _             _
            _         _ ( )           ( )
  ___ ___  (_)  ___  (_)| |/')  _   _ | |_      __
/' _ ` _ `\| |/' _ `\| || , <  ( ) ( )| '_`\  /'__`\
| ( ) ( ) || || ( ) || || |\`\ | (_) || |_) )(  ___/
(_) (_) (_)(_)(_) (_)(_)(_) (_)`\___/'(_,__/'`\____)

$ docker build^C
$ docker build -t services/nginx /srcs/nginx/
Sending build context to Docker daemon   5.12kB
Step 1/7 : FROM alpine:latest
 ---> e7d92cdc71fe
Step 2/7 : RUN apk update && apk add nginx && apk add --no-cache --upgrade bash && apk add openssl && mkdir -p var/run/nginx
 ---> Using cache
 ---> fc07cae4eeb5
Step 3/7 : RUN adduser -D -g 'www' www && mkdir /www && chown -R www:www /var/lib/nginx && chown -R www:www /www
 ---> Using cache
 ---> 5de7f53ecfac
Step 4/7 : RUN mkdir /etc/nginx/ssl && openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out /etc/nginx/ssl/www.pem -keyout /etc/nginx/ssl/www.key -subj "/C=FR/ST=Paris/L=Paris/O=42 School/OU=rchallie/CN=ft_services"
 ---> Using cache
 ---> cbd120a32f58
Step 5/7 : RUN rm /etc/nginx/nginx.conf
 ---> Using cache
 ---> 4b7a29f5fa7b
Step 6/7 : COPY ./nginx.conf /etc/nginx/nginx.conf
 ---> Using cache
 ---> a8e2a66c8fd4
Step 7/7 : CMD [ "nginx" , "-g", "daemon off;" ]
 ---> Using cache
 ---> d5081a2f4dd0
Successfully built d5081a2f4dd0
Successfully tagged services/nginx:latest
$ docker run --name test -p 80:80 -p 443:443 -ti -d services/nginx
da3421add148ae1853ccd6ed5373bd6d03691c40e1f29c8482ddf9b3109acc3f
docker: Error response from daemon: driver failed programming external connectivity on endpoint test (51dec920717fcd17ff4484bacc10dd0993228a82c2ea3ce0910c814253fc4dc6): Bind for 0.0.0.0:443 failed: port is already allocated.
$ vi /sr
srcs/ srv/
$ vi /srcs/nginx/
Dockerfile  nginx.conf
$ vi /srcs/nginx/nginx.conf
$ su
$ su root
$ vi /srcs/nginx/nginx.conf
$ su docker
$ docker build -t services/nginx /srcs/nginx/
Sending build context to Docker daemon   5.12kB
Step 1/7 : FROM alpine:latest
 ---> e7d92cdc71fe
Step 2/7 : RUN apk update && apk add nginx && apk add --no-cache --upgrade bash && apk add openssl && mkdir -p var/run/nginx
 ---> Using cache
 ---> fc07cae4eeb5
Step 3/7 : RUN adduser -D -g 'www' www && mkdir /www && chown -R www:www /var/lib/nginx && chown -R www:www /www
 ---> Using cache
 ---> 5de7f53ecfac
Step 4/7 : RUN mkdir /etc/nginx/ssl && openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out /etc/nginx/ssl/www.pem -keyout /etc/nginx/ssl/www.key -subj "/C=FR/ST=Paris/L=Paris/O=42 School/OU=rchallie/CN=ft_services"
 ---> Using cache
 ---> cbd120a32f58
Step 5/7 : RUN rm /etc/nginx/nginx.conf
 ---> Using cache
 ---> 4b7a29f5fa7b
Step 6/7 : COPY ./nginx.conf /etc/nginx/nginx.conf
 ---> 065ec2e2ca32
Step 7/7 : CMD [ "nginx" , "-g", "daemon off;" ]
 ---> Running in b6eefd595f1e
Removing intermediate container b6eefd595f1e
 ---> ad604ea7ab93
Successfully built ad604ea7ab93
Successfully tagged services/nginx:latest
$ exit
exit
$ exit
exit
$ exit
exit
$ exit
logout
➜  ft_services git:(master) ✗ kubectl apply -f ./ingress.yaml
service/nginx unchanged
deployment.apps/nginx-deployment unchanged
ingress.networking.k8s.io/example-ingress unchanged
➜  ft_services git:(master) ✗ kubectl apply -f ./ingress.yaml
service/nginx created
deployment.apps/nginx-deployment created
ingress.networking.k8s.io/example-ingress created
➜  ft_services git:(master) ✗ minikube ip
192.168.99.144
➜  ft_services git:(master) ✗ kubectl get ingress.yaml
^C
➜  ft_services git:(master) ✗ kubectl get ingress
NAME              HOSTS              ADDRESS          PORTS   AGE
example-ingress   hello-world.info   192.168.99.144   80      56s
➜  ft_services git:(master) ✗ minikube service nginx --url
http://192.168.99.144:30072
http://192.168.99.144:30401
➜  ft_services git:(master) ✗ kubectl get ingress
➜  ft_services git:(master) ✗ minikube ssh
                         _             _
            _         _ ( )           ( )
  ___ ___  (_)  ___  (_)| |/')  _   _ | |_      __
/' _ ` _ `\| |/' _ `\| || , <  ( ) ( )| '_`\  /'__`\
| ( ) ( ) || || ( ) || || |\`\ | (_) || |_) )(  ___/
(_) (_) (_)(_)(_) (_)(_)(_) (_)`\___/'(_,__/'`\____)

$ su root
$ vi /srcs/nginx/
Dockerfile  nginx.conf
$ vi /srcs/nginx/nginx.conf
$ exit
exit
$ exit
logout
➜  ft_services git:(master) ✗ kubectl delete deployment nginx
Error from server (NotFound): deployments.apps "nginx" not found
➜  ft_services git:(master) ✗ kubectl get deployment nginx
Error from server (NotFound): deployments.apps "nginx" not found
➜  ft_services git:(master) ✗ kubectl get deployment
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment   1/1     1            1           4m21s
➜  ft_services git:(master) ✗ kubectl delete deployment nginx-deployment
deployment.apps "nginx-deployment" deleted
➜  ft_services git:(master) ✗ minikube ssh
                         _             _
            _         _ ( )           ( )
  ___ ___  (_)  ___  (_)| |/')  _   _ | |_      __
/' _ ` _ `\| |/' _ `\| || , <  ( ) ( )| '_`\  /'__`\
| ( ) ( ) || || ( ) || || |\`\ | (_) || |_) )(  ___/
(_) (_) (_)(_)(_) (_)(_)(_) (_)`\___/'(_,__/'`\____)

$ su root
$ vi /srcs/nginx/nginx.conf
$ docker build -t services/nginx /srcs/nginx/
Sending build context to Docker daemon   5.12kB
Step 1/7 : FROM alpine:latest
 ---> e7d92cdc71fe
Step 2/7 : RUN apk update && apk add nginx && apk add --no-cache --upgrade bash && apk add openssl && mkdir -p var/run/nginx
 ---> Using cache
 ---> fc07cae4eeb5
Step 3/7 : RUN adduser -D -g 'www' www && mkdir /www && chown -R www:www /var/lib/nginx && chown -R www:www /www
 ---> Using cache
 ---> 5de7f53ecfac
Step 4/7 : RUN mkdir /etc/nginx/ssl && openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out /etc/nginx/ssl/www.pem -keyout /etc/nginx/ssl/www.key -subj "/C=FR/ST=Paris/L=Paris/O=42 School/OU=rchallie/CN=ft_services"
 ---> Using cache
 ---> cbd120a32f58
Step 5/7 : RUN rm /etc/nginx/nginx.conf
 ---> Using cache
 ---> 4b7a29f5fa7b
Step 6/7 : COPY ./nginx.conf /etc/nginx/nginx.conf
 ---> d1fad962021a
Step 7/7 : CMD [ "nginx" , "-g", "daemon off;" ]
 ---> Running in 504aca4ce4d5
Removing intermediate container 504aca4ce4d5
 ---> 90deca660daa
Successfully built 90deca660daa
Successfully tagged services/nginx:latest
$ exit
exit
$ exit
logout
➜  ft_services git:(master) ✗ minikube ssh
                         _             _
            _         _ ( )           ( )
  ___ ___  (_)  ___  (_)| |/')  _   _ | |_      __
/' _ ` _ `\| |/' _ `\| || , <  ( ) ( )| '_`\  /'__`\
| ( ) ( ) || || ( ) || || |\`\ | (_) || |_) )(  ___/
(_) (_) (_)(_)(_) (_)(_)(_) (_)`\___/'(_,__/'`\____)

$ docker build -t services/nginx /srcs/nginx/
Sending build context to Docker daemon   5.12kB
Step 1/7 : FROM alpine:latest
 ---> e7d92cdc71fe
Step 2/7 : RUN apk update && apk add nginx && apk add --no-cache --upgrade bash && apk add openssl && mkdir -p var/run/nginx
 ---> Using cache
 ---> fc07cae4eeb5
Step 3/7 : RUN adduser -D -g 'www' www && mkdir /www && chown -R www:www /var/lib/nginx && chown -R www:www /www
 ---> Using cache
 ---> 5de7f53ecfac
Step 4/7 : RUN mkdir /etc/nginx/ssl && openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out /etc/nginx/ssl/www.pem -keyout /etc/nginx/ssl/www.key -subj "/C=FR/ST=Paris/L=Paris/O=42 School/OU=rchallie/CN=ft_services"
 ---> Using cache
 ---> cbd120a32f58
Step 5/7 : RUN rm /etc/nginx/nginx.conf
 ---> Using cache
 ---> 4b7a29f5fa7b
Step 6/7 : COPY ./nginx.conf /etc/nginx/nginx.conf
 ---> Using cache
 ---> d1fad962021a
Step 7/7 : CMD [ "nginx" , "-g", "daemon off;" ]
 ---> Using cache
 ---> 90deca660daa
Successfully built 90deca660daa
Successfully tagged services/nginx:latest
$ exit
logout
➜  ft_services git:(master) ✗ kubectl apply -f ./ingress.yaml
service/nginx created
deployment.apps/nginx-deployment created
ingress.networking.k8s.io/example-ingress created
➜  ft_services git:(master) ✗ minikube service nginx --url
http://192.168.99.144:31083
http://192.168.99.144:30755
➜  ft_services git:(master) ✗ kubectl apply -f ./ingress.yaml
service/nginx unchanged
deployment.apps/nginx-deployment unchanged
ingress.networking.k8s.io/example-ingress configured
➜  ft_services git:(master) ✗ kubectl apply -f ./ingress.yaml
service/nginx-svc created
deployment.apps/nginx-deployment configured
ingress.networking.k8s.io/example-ingress unchanged
➜  ft_services git:(master) ✗ minikube ssh
                         _             _
            _         _ ( )           ( )
  ___ ___  (_)  ___  (_)| |/')  _   _ | |_      __
/' _ ` _ `\| |/' _ `\| || , <  ( ) ( )| '_`\  /'__`\
| ( ) ( ) || || ( ) || || |\`\ | (_) || |_) )(  ___/
(_) (_) (_)(_)(_) (_)(_)(_) (_)`\___/'(_,__/'`\____)

$ docker ps -a
CONTAINER ID        IMAGE                                                            COMMAND                  CREATED              STATUS                        PORTS                                                                NAMES
890b1f9a28b8        90deca660daa                                                     "nginx -g 'daemon of…"   About a minute ago   Up About a minute                                                                                  k8s_nginx-svc_nginx-deployment-775c948fd9-4k7mq_default_2e82a005-c187-4401-9625-8788136312f0_0
a3ddf4f93ec9        k8s.gcr.io/pause:3.1                                             "/pause"                 About a minute ago   Up About a minute                                                                                  k8s_POD_nginx-deployment-775c948fd9-4k7mq_default_2e82a005-c187-4401-9625-8788136312f0_0
da3421add148        d5081a2f4dd0                                                     "nginx -g 'daemon of…"   17 minutes ago       Created                                                                                            test
0f898e76a6de        3b08661dc379                                                     "/metrics-sidecar"       19 minutes ago       Up 19 minutes                                                                                      k8s_dashboard-metrics-scraper_dashboard-metrics-scraper-7b64584c5c-gxcv6_kubernetes-dashboard_66c20f06-dc55-4efc-821d-e13259d74711_0
8360f93df60c        eb51a3597525                                                     "/dashboard --insecu…"   19 minutes ago       Up 19 minutes                                                                                      k8s_kubernetes-dashboard_kubernetes-dashboard-79d9cd965-zv2vx_kubernetes-dashboard_f8ce0b8d-58f7-42b6-979f-b994f0d6511e_0
4338850d9bc7        k8s.gcr.io/pause:3.1                                             "/pause"                 19 minutes ago       Up 19 minutes                                                                                      k8s_POD_dashboard-metrics-scraper-7b64584c5c-gxcv6_kubernetes-dashboard_66c20f06-dc55-4efc-821d-e13259d74711_0
5b0378551335        k8s.gcr.io/pause:3.1                                             "/pause"                 19 minutes ago       Up 19 minutes                                                                                      k8s_POD_kubernetes-dashboard-79d9cd965-zv2vx_kubernetes-dashboard_f8ce0b8d-58f7-42b6-979f-b994f0d6511e_0
41e3be66fc1e        quay.io/kubernetes-ingress-controller/nginx-ingress-controller   "/usr/bin/dumb-init …"   46 minutes ago       Up 46 minutes                                                                                      k8s_nginx-ingress-controller_nginx-ingress-controller-6fc5bcc8c9-fszbj_kube-system_39fdda21-236c-4f19-91c2-28ad34c89753_0
ebea3f413f59        70f311871ae1                                                     "/coredns -conf /etc…"   47 minutes ago       Up 47 minutes                                                                                      k8s_coredns_coredns-6955765f44-8wjqj_kube-system_b35f9cb7-da47-45ed-b37b-39f0129f1617_0
68f8d3a11cc4        70f311871ae1                                                     "/coredns -conf /etc…"   47 minutes ago       Up 47 minutes                                                                                      k8s_coredns_coredns-6955765f44-6cbrm_kube-system_eb81f394-16f2-4e2d-a22d-8497970aca73_0
4c8fe4c2250f        4689081edb10                                                     "/storage-provisioner"   47 minutes ago       Up 47 minutes                                                                                      k8s_storage-provisioner_storage-provisioner_kube-system_19c2365e-a70f-4fb6-94c9-f32f1ea70a7b_0
f574d79ca369        k8s.gcr.io/pause:3.1                                             "/pause"                 47 minutes ago       Up 47 minutes                 0.0.0.0:80->80/tcp, 0.0.0.0:443->443/tcp, 0.0.0.0:18080->18080/tcp   k8s_POD_nginx-ingress-controller-6fc5bcc8c9-fszbj_kube-system_39fdda21-236c-4f19-91c2-28ad34c89753_0
be2575b36449        k8s.gcr.io/pause:3.1                                             "/pause"                 47 minutes ago       Up 47 minutes                                                                                      k8s_POD_storage-provisioner_kube-system_19c2365e-a70f-4fb6-94c9-f32f1ea70a7b_0
dce14504423b        k8s.gcr.io/pause:3.1                                             "/pause"                 47 minutes ago       Up 47 minutes                                                                                      k8s_POD_coredns-6955765f44-8wjqj_kube-system_b35f9cb7-da47-45ed-b37b-39f0129f1617_0
9ba3d72a1d8b        k8s.gcr.io/pause:3.1                                             "/pause"                 47 minutes ago       Up 47 minutes                                                                                      k8s_POD_coredns-6955765f44-6cbrm_kube-system_eb81f394-16f2-4e2d-a22d-8497970aca73_0
bb0220d5bd7c        7d54289267dc                                                     "/usr/local/bin/kube…"   47 minutes ago       Up 47 minutes                                                                                      k8s_kube-proxy_kube-proxy-8bnm6_kube-system_7b5caf06-3997-469a-b70c-80ba4e4abbeb_0
b5f49ca06d32        k8s.gcr.io/pause:3.1                                             "/pause"                 47 minutes ago       Up 47 minutes                                                                                      k8s_POD_kube-proxy-8bnm6_kube-system_7b5caf06-3997-469a-b70c-80ba4e4abbeb_0
d80f3f663d58        bd12a212f9dc                                                     "/opt/kube-addons.sh"    48 minutes ago       Up 48 minutes                                                                                      k8s_kube-addon-manager_kube-addon-manager-minikube_kube-system_c3e29047da86ce6690916750ab69c40b_1
3a376202d92b        78c190f736b1                                                     "kube-scheduler --au…"   48 minutes ago       Up 48 minutes                                                                                      k8s_kube-scheduler_kube-scheduler-minikube_kube-system_ff67867321338ffd885039e188f6b424_1
9e2512fe1d3b        303ce5db0e90                                                     "etcd --advertise-cl…"   48 minutes ago       Up 48 minutes                                                                                      k8s_etcd_etcd-minikube_kube-system_28d1728e6a61bf9ba179c9eceb4a8f6f_1
cedc7bde5cf1        5eb3b7486872                                                     "kube-controller-man…"   48 minutes ago       Up 48 minutes                                                                                      k8s_kube-controller-manager_kube-controller-manager-minikube_kube-system_e7ce3a6ee9fa0ec547ac7b4b17af0dcb_1
13bca11fb179        0cae8d5cc64c                                                     "kube-apiserver --ad…"   48 minutes ago       Up 48 minutes                                                                                      k8s_kube-apiserver_kube-apiserver-minikube_kube-system_79dee1a74dcabda625eeaf3813e600b2_1
b6752acbaf24        k8s.gcr.io/pause:3.1                                             "/pause"                 48 minutes ago       Up 48 minutes                                                                                      k8s_POD_etcd-minikube_kube-system_28d1728e6a61bf9ba179c9eceb4a8f6f_1
f6d5bf94a54f        k8s.gcr.io/pause:3.1                                             "/pause"                 48 minutes ago       Up 48 minutes                                                                                      k8s_POD_kube-scheduler-minikube_kube-system_ff67867321338ffd885039e188f6b424_1
677a037def0b        k8s.gcr.io/pause:3.1                                             "/pause"                 48 minutes ago       Up 48 minutes                                                                                      k8s_POD_kube-controller-manager-minikube_kube-system_e7ce3a6ee9fa0ec547ac7b4b17af0dcb_1
da2b78ae2073        k8s.gcr.io/pause:3.1                                             "/pause"                 48 minutes ago       Up 48 minutes                                                                                      k8s_POD_kube-apiserver-minikube_kube-system_79dee1a74dcabda625eeaf3813e600b2_1
4800b3805cfd        k8s.gcr.io/pause:3.1                                             "/pause"                 48 minutes ago       Up 48 minutes                                                                                      k8s_POD_kube-addon-manager-minikube_kube-system_c3e29047da86ce6690916750ab69c40b_1
a73325070dca        78c190f736b1                                                     "kube-scheduler --au…"   49 minutes ago       Exited (2) 49 minutes ago                                                                          k8s_kube-scheduler_kube-scheduler-minikube_kube-system_ff67867321338ffd885039e188f6b424_0
b63519fe695d        303ce5db0e90                                                     "etcd --advertise-cl…"   49 minutes ago       Exited (0) 49 minutes ago                                                                          k8s_etcd_etcd-minikube_kube-system_28d1728e6a61bf9ba179c9eceb4a8f6f_0
883e9df5c419        bd12a212f9dc                                                     "/opt/kube-addons.sh"    49 minutes ago       Exited (137) 49 minutes ago                                                                        k8s_kube-addon-manager_kube-addon-manager-minikube_kube-system_c3e29047da86ce6690916750ab69c40b_0
986aeb30a9e9        5eb3b7486872                                                     "kube-controller-man…"   49 minutes ago       Exited (2) 49 minutes ago                                                                          k8s_kube-controller-manager_kube-controller-manager-minikube_kube-system_e7ce3a6ee9fa0ec547ac7b4b17af0dcb_0
bb1a57c415dc        0cae8d5cc64c                                                     "kube-apiserver --ad…"   49 minutes ago       Exited (137) 49 minutes ago                                                                        k8s_kube-apiserver_kube-apiserver-minikube_kube-system_79dee1a74dcabda625eeaf3813e600b2_0
35259e47b4d4        k8s.gcr.io/pause:3.1                                             "/pause"                 49 minutes ago       Exited (0) 49 minutes ago                                                                          k8s_POD_etcd-minikube_kube-system_28d1728e6a61bf9ba179c9eceb4a8f6f_0
3123f8c67641        k8s.gcr.io/pause:3.1                                             "/pause"                 49 minutes ago       Exited (0) 49 minutes ago                                                                          k8s_POD_kube-scheduler-minikube_kube-system_ff67867321338ffd885039e188f6b424_0
986d8abedd2d        k8s.gcr.io/pause:3.1                                             "/pause"                 49 minutes ago       Exited (0) 49 minutes ago                                                                          k8s_POD_kube-controller-manager-minikube_kube-system_e7ce3a6ee9fa0ec547ac7b4b17af0dcb_0
231b77699d84        k8s.gcr.io/pause:3.1                                             "/pause"                 49 minutes ago       Exited (0) 49 minutes ago                                                                          k8s_POD_kube-apiserver-minikube_kube-system_79dee1a74dcabda625eeaf3813e600b2_0
74ccb376407a        k8s.gcr.io/pause:3.1                                             "/pause"                 49 minutes ago       Exited (0) 49 minutes ago                                                                          k8s_POD_kube-addon-manager-minikube_kube-system_c3e29047da86ce6690916750ab69c40b_0
$ docker stop test && docker rm test
test
test
$ docker ps -a
CONTAINER ID        IMAGE                                                            COMMAND                  CREATED              STATUS                        PORTS                                                                NAMES
890b1f9a28b8        90deca660daa                                                     "nginx -g 'daemon of…"   About a minute ago   Up About a minute                                                                                  k8s_nginx-svc_nginx-deployment-775c948fd9-4k7mq_default_2e82a005-c187-4401-9625-8788136312f0_0
a3ddf4f93ec9        k8s.gcr.io/pause:3.1                                             "/pause"                 About a minute ago   Up About a minute                                                                                  k8s_POD_nginx-deployment-775c948fd9-4k7mq_default_2e82a005-c187-4401-9625-8788136312f0_0
0f898e76a6de        3b08661dc379                                                     "/metrics-sidecar"       20 minutes ago       Up 20 minutes                                                                                      k8s_dashboard-metrics-scraper_dashboard-metrics-scraper-7b64584c5c-gxcv6_kubernetes-dashboard_66c20f06-dc55-4efc-821d-e13259d74711_0
8360f93df60c        eb51a3597525                                                     "/dashboard --insecu…"   20 minutes ago       Up 20 minutes                                                                                      k8s_kubernetes-dashboard_kubernetes-dashboard-79d9cd965-zv2vx_kubernetes-dashboard_f8ce0b8d-58f7-42b6-979f-b994f0d6511e_0
4338850d9bc7        k8s.gcr.io/pause:3.1                                             "/pause"                 20 minutes ago       Up 20 minutes                                                                                      k8s_POD_dashboard-metrics-scraper-7b64584c5c-gxcv6_kubernetes-dashboard_66c20f06-dc55-4efc-821d-e13259d74711_0
5b0378551335        k8s.gcr.io/pause:3.1                                             "/pause"                 20 minutes ago       Up 20 minutes                                                                                      k8s_POD_kubernetes-dashboard-79d9cd965-zv2vx_kubernetes-dashboard_f8ce0b8d-58f7-42b6-979f-b994f0d6511e_0
41e3be66fc1e        quay.io/kubernetes-ingress-controller/nginx-ingress-controller   "/usr/bin/dumb-init …"   47 minutes ago       Up 47 minutes                                                                                      k8s_nginx-ingress-controller_nginx-ingress-controller-6fc5bcc8c9-fszbj_kube-system_39fdda21-236c-4f19-91c2-28ad34c89753_0
ebea3f413f59        70f311871ae1                                                     "/coredns -conf /etc…"   47 minutes ago       Up 47 minutes                                                                                      k8s_coredns_coredns-6955765f44-8wjqj_kube-system_b35f9cb7-da47-45ed-b37b-39f0129f1617_0
68f8d3a11cc4        70f311871ae1                                                     "/coredns -conf /etc…"   47 minutes ago       Up 47 minutes                                                                                      k8s_coredns_coredns-6955765f44-6cbrm_kube-system_eb81f394-16f2-4e2d-a22d-8497970aca73_0
4c8fe4c2250f        4689081edb10                                                     "/storage-provisioner"   47 minutes ago       Up 47 minutes                                                                                      k8s_storage-provisioner_storage-provisioner_kube-system_19c2365e-a70f-4fb6-94c9-f32f1ea70a7b_0
f574d79ca369        k8s.gcr.io/pause:3.1                                             "/pause"                 47 minutes ago       Up 47 minutes                 0.0.0.0:80->80/tcp, 0.0.0.0:443->443/tcp, 0.0.0.0:18080->18080/tcp   k8s_POD_nginx-ingress-controller-6fc5bcc8c9-fszbj_kube-system_39fdda21-236c-4f19-91c2-28ad34c89753_0
be2575b36449        k8s.gcr.io/pause:3.1                                             "/pause"                 47 minutes ago       Up 47 minutes                                                                                      k8s_POD_storage-provisioner_kube-system_19c2365e-a70f-4fb6-94c9-f32f1ea70a7b_0
dce14504423b        k8s.gcr.io/pause:3.1                                             "/pause"                 47 minutes ago       Up 47 minutes                                                                                      k8s_POD_coredns-6955765f44-8wjqj_kube-system_b35f9cb7-da47-45ed-b37b-39f0129f1617_0
9ba3d72a1d8b        k8s.gcr.io/pause:3.1                                             "/pause"                 47 minutes ago       Up 47 minutes                                                                                      k8s_POD_coredns-6955765f44-6cbrm_kube-system_eb81f394-16f2-4e2d-a22d-8497970aca73_0
bb0220d5bd7c        7d54289267dc                                                     "/usr/local/bin/kube…"   48 minutes ago       Up 48 minutes                                                                                      k8s_kube-proxy_kube-proxy-8bnm6_kube-system_7b5caf06-3997-469a-b70c-80ba4e4abbeb_0
b5f49ca06d32        k8s.gcr.io/pause:3.1                                             "/pause"                 48 minutes ago       Up 48 minutes                                                                                      k8s_POD_kube-proxy-8bnm6_kube-system_7b5caf06-3997-469a-b70c-80ba4e4abbeb_0
d80f3f663d58        bd12a212f9dc                                                     "/opt/kube-addons.sh"    48 minutes ago       Up 48 minutes                                                                                      k8s_kube-addon-manager_kube-addon-manager-minikube_kube-system_c3e29047da86ce6690916750ab69c40b_1
3a376202d92b        78c190f736b1                                                     "kube-scheduler --au…"   48 minutes ago       Up 48 minutes                                                                                      k8s_kube-scheduler_kube-scheduler-minikube_kube-system_ff67867321338ffd885039e188f6b424_1
9e2512fe1d3b        303ce5db0e90                                                     "etcd --advertise-cl…"   48 minutes ago       Up 48 minutes                                                                                      k8s_etcd_etcd-minikube_kube-system_28d1728e6a61bf9ba179c9eceb4a8f6f_1
cedc7bde5cf1        5eb3b7486872                                                     "kube-controller-man…"   48 minutes ago       Up 48 minutes                                                                                      k8s_kube-controller-manager_kube-controller-manager-minikube_kube-system_e7ce3a6ee9fa0ec547ac7b4b17af0dcb_1
13bca11fb179        0cae8d5cc64c                                                     "kube-apiserver --ad…"   48 minutes ago       Up 48 minutes                                                                                      k8s_kube-apiserver_kube-apiserver-minikube_kube-system_79dee1a74dcabda625eeaf3813e600b2_1
b6752acbaf24        k8s.gcr.io/pause:3.1                                             "/pause"                 48 minutes ago       Up 48 minutes                                                                                      k8s_POD_etcd-minikube_kube-system_28d1728e6a61bf9ba179c9eceb4a8f6f_1
f6d5bf94a54f        k8s.gcr.io/pause:3.1                                             "/pause"                 48 minutes ago       Up 48 minutes                                                                                      k8s_POD_kube-scheduler-minikube_kube-system_ff67867321338ffd885039e188f6b424_1
677a037def0b        k8s.gcr.io/pause:3.1                                             "/pause"                 48 minutes ago       Up 48 minutes                                                                                      k8s_POD_kube-controller-manager-minikube_kube-system_e7ce3a6ee9fa0ec547ac7b4b17af0dcb_1
da2b78ae2073        k8s.gcr.io/pause:3.1                                             "/pause"                 48 minutes ago       Up 48 minutes                                                                                      k8s_POD_kube-apiserver-minikube_kube-system_79dee1a74dcabda625eeaf3813e600b2_1
4800b3805cfd        k8s.gcr.io/pause:3.1                                             "/pause"                 48 minutes ago       Up 48 minutes                                                                                      k8s_POD_kube-addon-manager-minikube_kube-system_c3e29047da86ce6690916750ab69c40b_1
a73325070dca        78c190f736b1                                                     "kube-scheduler --au…"   50 minutes ago       Exited (2) 49 minutes ago                                                                          k8s_kube-scheduler_kube-scheduler-minikube_kube-system_ff67867321338ffd885039e188f6b424_0
b63519fe695d        303ce5db0e90                                                     "etcd --advertise-cl…"   50 minutes ago       Exited (0) 49 minutes ago                                                                          k8s_etcd_etcd-minikube_kube-system_28d1728e6a61bf9ba179c9eceb4a8f6f_0
883e9df5c419        bd12a212f9dc                                                     "/opt/kube-addons.sh"    50 minutes ago       Exited (137) 49 minutes ago                                                                        k8s_kube-addon-manager_kube-addon-manager-minikube_kube-system_c3e29047da86ce6690916750ab69c40b_0
986aeb30a9e9        5eb3b7486872                                                     "kube-controller-man…"   50 minutes ago       Exited (2) 49 minutes ago                                                                          k8s_kube-controller-manager_kube-controller-manager-minikube_kube-system_e7ce3a6ee9fa0ec547ac7b4b17af0dcb_0
bb1a57c415dc        0cae8d5cc64c                                                     "kube-apiserver --ad…"   50 minutes ago       Exited (137) 49 minutes ago                                                                        k8s_kube-apiserver_kube-apiserver-minikube_kube-system_79dee1a74dcabda625eeaf3813e600b2_0
35259e47b4d4        k8s.gcr.io/pause:3.1                                             "/pause"                 50 minutes ago       Exited (0) 49 minutes ago                                                                          k8s_POD_etcd-minikube_kube-system_28d1728e6a61bf9ba179c9eceb4a8f6f_0
3123f8c67641        k8s.gcr.io/pause:3.1                                             "/pause"                 50 minutes ago       Exited (0) 49 minutes ago                                                                          k8s_POD_kube-scheduler-minikube_kube-system_ff67867321338ffd885039e188f6b424_0
986d8abedd2d        k8s.gcr.io/pause:3.1                                             "/pause"                 50 minutes ago       Exited (0) 49 minutes ago                                                                          k8s_POD_kube-controller-manager-minikube_kube-system_e7ce3a6ee9fa0ec547ac7b4b17af0dcb_0
231b77699d84        k8s.gcr.io/pause:3.1                                             "/pause"                 50 minutes ago       Exited (0) 49 minutes ago                                                                          k8s_POD_kube-apiserver-minikube_kube-system_79dee1a74dcabda625eeaf3813e600b2_0
74ccb376407a        k8s.gcr.io/pause:3.1                                             "/pause"                 50 minutes ago       Exited (0) 49 minutes ago                                                                          k8s_POD_kube-addon-manager-minikube_kube-system_c3e29047da86ce6690916750ab69c40b_0
$ exit
logout
➜  ft_services git:(master) ✗ kubectl apply -f ./ingress.yaml
service/nginx-svc unchanged
deployment.apps/nginx-deployment unchanged
ingress.networking.k8s.io/example-ingress configured
➜  ft_services git:(master) ✗ kubectl apply -f ./ingress.yaml
service/nginx-svc unchanged
deployment.apps/nginx-deployment unchanged
ingress.networking.k8s.io/example-ingress configured
➜  ft_services git:(master) ✗ kubectl apply -f ./ingress.yaml
service/nginx-svc created
deployment.apps/nginx-deployment created
ingress.networking.k8s.io/example-ingress created
➜  ft_services git:(master) ✗ kubectl get ingress
^C
➜  ft_services git:(master) ✗ kubectl get ingresses
NAME              HOSTS         ADDRESS          PORTS   AGE
example-ingress   foo.bar.com   192.168.99.144   80      46s
➜  ft_services git:(master) ✗ kubectl get ingress
➜  ft_services git:(master) ✗ kubectl get ingressed
^C
➜  ft_services git:(master) ✗ kubectl get ingresses
NAME              HOSTS         ADDRESS          PORTS   AGE
example-ingress   foo.bar.com   192.168.99.144   80      9m5s
➜  ft_services git:(master) ✗ kubectl get ingresses
➜  ft_services git:(master) ✗ kubectl apply -f ./ingress.yaml
service/nginx-svc unchanged
deployment.apps/nginx-deployment unchanged
ingress.networking.k8s.io/nginx-ingress created
➜  ft_services git:(master) ✗ kubectl get ingresses
NAME            HOSTS   ADDRESS   PORTS   AGE
nginx-ingress   *                 80      6s
➜  ft_services git:(master) ✗ kubectl get ingresses
NAME            HOSTS   ADDRESS   PORTS   AGE
nginx-ingress   *                 80      8s
➜  ft_services git:(master) ✗ kubectl get ingresses
NAME            HOSTS   ADDRESS   PORTS   AGE
nginx-ingress   *                 80      9s
➜  ft_services git:(master) ✗ kubectl get ingresses
NAME            HOSTS   ADDRESS   PORTS   AGE
nginx-ingress   *                 80      9s
➜  ft_services git:(master) ✗ kubectl get ingresses
NAME            HOSTS   ADDRESS   PORTS   AGE
nginx-ingress   *                 80      10s
➜  ft_services git:(master) ✗ kubectl get ingresses
NAME            HOSTS   ADDRESS   PORTS   AGE
nginx-ingress   *                 80      11s
➜  ft_services git:(master) ✗ kubectl get ingresses
NAME            HOSTS   ADDRESS   PORTS   AGE
nginx-ingress   *                 80      11s
➜  ft_services git:(master) ✗ kubectl get ingresses
NAME            HOSTS   ADDRESS   PORTS   AGE
nginx-ingress   *                 80      12s
➜  ft_services git:(master) ✗ kubectl get ingresses
NAME            HOSTS   ADDRESS   PORTS   AGE
nginx-ingress   *                 80      12s
➜  ft_services git:(master) ✗ kubectl get ingresses
NAME            HOSTS   ADDRESS   PORTS   AGE
nginx-ingress   *                 80      13s
➜  ft_services git:(master) ✗ kubectl get ingresses
NAME            HOSTS   ADDRESS   PORTS   AGE
nginx-ingress   *                 80      16s
➜  ft_services git:(master) ✗ kubectl get ingresses
NAME            HOSTS   ADDRESS   PORTS   AGE
nginx-ingress   *                 80      30s
➜  ft_services git:(master) ✗ kubectl apply -f ./ingress.yaml
service/nginx-svc unchanged
deployment.apps/nginx-deployment unchanged
ingress.networking.k8s.io/nginx-ingress configured
➜  ft_services git:(master) ✗ kubectl get ingresses
NAME            HOSTS   ADDRESS          PORTS   AGE
nginx-ingress   *       192.168.99.144   80      92s
➜  ft_services git:(master) ✗ minikubemin
➜  ft_services git:(master) ✗ minikube ssh
                         _             _
            _         _ ( )           ( )
  ___ ___  (_)  ___  (_)| |/')  _   _ | |_      __
/' _ ` _ `\| |/' _ `\| || , <  ( ) ( )| '_`\  /'__`\
| ( ) ( ) || || ( ) || || |\`\ | (_) || |_) )(  ___/
(_) (_) (_)(_)(_) (_)(_)(_) (_)`\___/'(_,__/'`\____)

$ cd
$ cd /
$ ls
Users  bin  data  dev  etc  home  init	lib  lib64  linuxrc  media  mnt  opt  proc  root  run  sbin  srcs  srv	sys  tmp  usr  var
$ exit
logout
➜  ft_services git:(master) ✗ kubectl apply -f ./ingress.yaml
service/nginx-svc unchanged
deployment.apps/nginx-deployment unchanged
ingress.networking.k8s.io/nginx-ingress created
➜  ft_services git:(master) ✗ kubectl get ingresses
NAME            HOSTS   ADDRESS   PORTS   AGE
nginx-ingress   *                 80      8s
➜  ft_services git:(master) ✗ kubectl get ingresses
NAME            HOSTS   ADDRESS   PORTS   AGE
nginx-ingress   *                 80      9s
➜  ft_services git:(master) ✗ kubectl get ingresses
NAME            HOSTS   ADDRESS   PORTS   AGE
nginx-ingress   *                 80      11s
➜  ft_services git:(master) ✗ kubectl get ingresses
NAME            HOSTS   ADDRESS   PORTS   AGE
nginx-ingress   *                 80      12s
➜  ft_services git:(master) ✗ kubectl get ingresses
NAME            HOSTS   ADDRESS   PORTS   AGE
nginx-ingress   *                 80      13s
➜  ft_services git:(master) ✗ kubectl get ingresses
NAME            HOSTS   ADDRESS   PORTS   AGE
nginx-ingress   *                 80      15s
➜  ft_services git:(master) ✗ kubectl get ingresses
NAME            HOSTS   ADDRESS          PORTS   AGE
nginx-ingress   *       192.168.99.144   80      24s
➜  ft_services git:(master) ✗ kubectl apply -f ./ingress.yaml
service/nginx-svc created
deployment.apps/nginx-deployment created
ingress.networking.k8s.io/nginx-ingress created
➜  ft_services git:(master) ✗ kubectl get ingresses
NAME            HOSTS   ADDRESS   PORTS   AGE
nginx-ingress   *                 80      9s
➜  ft_services git:(master) ✗ kubectl get ingresses
NAME            HOSTS   ADDRESS   PORTS   AGE
nginx-ingress   *                 80      10s
➜  ft_services git:(master) ✗ kubectl get ingresses
NAME            HOSTS   ADDRESS   PORTS   AGE
nginx-ingress   *                 80      12s
➜  ft_services git:(master) ✗ kubectl get ingresses
NAME            HOSTS   ADDRESS   PORTS   AGE
nginx-ingress   *                 80      12s
➜  ft_services git:(master) ✗ kubectl get ingresses
NAME            HOSTS   ADDRESS   PORTS   AGE
nginx-ingress   *                 80      14s
➜  ft_services git:(master) ✗ kubectl get ingresses
NAME            HOSTS   ADDRESS   PORTS   AGE
nginx-ingress   *                 80      14s
➜  ft_services git:(master) ✗ kubectl get ingresses
NAME            HOSTS   ADDRESS   PORTS   AGE
nginx-ingress   *                 80      15s
➜  ft_services git:(master) ✗ kubectl get ingresses
NAME            HOSTS   ADDRESS   PORTS   AGE
nginx-ingress   *                 80      17s
➜  ft_services git:(master) ✗ curl 192.168.99.144
<html>
<head><title>Index of /</title></head>
<body>
<h1>Index of /</h1><hr><pre><a href="../">../</a>
</pre><hr></body>
</html>
➜  ft_services git:(master) ✗ curl 192.168.99.144
<html>
<head><title>404 Not Found</title></head>
<body>
<center><h1>404 Not Found</h1></center>
<hr><center>openresty/1.15.8.2</center>
</body>
</html>
➜  ft_services git:(master) ✗ kubectl apply -f ./ingress.yaml
service/nginx-svc created
deployment.apps/nginx-deployment created
ingress.networking.k8s.io/nginx-ingress created
➜  ft_services git:(master) ✗ curl 192.168.99.144
<html>
<head><title>404 Not Found</title></head>
<body>
<center><h1>404 Not Found</h1></center>
<hr><center>openresty/1.15.8.2</center>
</body>
</html>
➜  ft_services git:(master) ✗ curl 192.168.99.144
<html>
<head><title>404 Not Found</title></head>
<body>
<center><h1>404 Not Found</h1></center>
<hr><center>openresty/1.15.8.2</center>
</body>
</html>
➜  ft_services git:(master) ✗
➜  ft_services git:(master) ✗ curl 192.168.99.144
<html>
<head><title>Index of /</title></head>
<body>
<h1>Index of /</h1><hr><pre><a href="../">../</a>
</pre><hr></body>
</html>
➜  ft_services git:(master) ✗ kubectl get ingresses
NAME            HOSTS   ADDRESS   PORTS   AGE
nginx-ingress   *                 80      13s
➜  ft_services git:(master) ✗ curl 192.168.99.144
<html>
<head><title>Index of /</title></head>
<body>
<h1>Index of /</h1><hr><pre><a href="../">../</a>
</pre><hr></body>
</html>
➜  ft_services git:(master) ✗ curl 192.168.99.144
<html>
<head><title>404 Not Found</title></head>
<body>
<center><h1>404 Not Found</h1></center>
<hr><center>openresty/1.15.8.2</center>
</body>
</html>
➜  ft_services git:(master) ✗ kubectl apply -f ./ingress.yaml
service/nginx-svc created
deployment.apps/nginx-deployment created
error: error validating "./ingress.yaml": error validating data: [ValidationError(Ingress.spec.rules[0].http.paths[0]): unknown field "host" in io.k8s.api.networking.v1beta1.HTTPIngressPath, ValidationError(Ingress.spec.rules[0].http.paths[0]): missing required field "backend" in io.k8s.api.networking.v1beta1.HTTPIngressPath]; if you choose to ignore these errors, turn validation off with --validate=false
➜  ft_services git:(master) ✗ kubectl apply -f ./ingress.yaml
service/nginx-svc unchanged
deployment.apps/nginx-deployment unchanged
The Ingress "nginx-ingress" is invalid: spec.rules[0].host: Invalid value: "ft_services.42": a DNS-1123 subdomain must consist of lower case alphanumeric characters, '-' or '.', and must start and end with an alphanumeric character (e.g. 'example.com', regex used for validation is '[a-z0-9]([-a-z0-9]*[a-z0-9])?(\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*')
➜  ft_services git:(master) ✗ kubectl apply -f ./ingress.yaml
service/nginx-svc unchanged
deployment.apps/nginx-deployment unchanged
The Ingress "nginx-ingress" is invalid: spec.rules[0].host: Invalid value: "ft_services.rchallie": a DNS-1123 subdomain must consist of lower case alphanumeric characters, '-' or '.', and must start and end with an alphanumeric character (e.g. 'example.com', regex used for validation is '[a-z0-9]([-a-z0-9]*[a-z0-9])?(\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*')
➜  ft_services git:(master) ✗ kubectl apply -f ./ingress.yaml
service/nginx-svc unchanged
deployment.apps/nginx-deployment unchanged
ingress.networking.k8s.io/nginx-ingress created
➜  ft_services git:(master) ✗ curl 192.168.99.144
<html>
<head><title>Index of /</title></head>
<body>
<h1>Index of /</h1><hr><pre><a href="../">../</a>
</pre><hr></body>
</html>
➜  ft_services git:(master) ✗ curl ftservices.rchallie
curl: (6) Could not resolve host: ftservices.rchallie
➜  ft_services git:(master) ✗ curl https://ftservices.rchallie
curl: (6) Could not resolve host: ftservices.rchallie
➜  ft_services git:(master) ✗ curl http://ftservices.rchallie
curl: (6) Could not resolve host: ftservices.rchallie
➜  ft_services git:(master) ✗ kubectl get ingresses
NAME            HOSTS                 ADDRESS          PORTS   AGE
nginx-ingress   ftservices.rchallie   192.168.99.144   80      54s
➜  ft_services git:(master) ✗ kubectl apply -f ./ingress.yaml
service/nginx-svc unchanged
deployment.apps/nginx-deployment unchanged
ingress.networking.k8s.io/nginx-ingress configured
➜  ft_services git:(master) ✗ kubectl get ingresses
NAME            HOSTS       ADDRESS          PORTS   AGE
nginx-ingress   localhost   192.168.99.144   80      2m43s
➜  ft_services git:(master) ✗ kubectl get ingressed
➜  ft_services git:(master) ✗ curl -kL http://localhost/
curl: (7) Failed to connect to localhost port 80: Connection refused
➜  ft_services git:(master) ✗ curl localhost
curl: (7) Failed to connect to localhost port 80: Connection refused

➜  ft_services git:(master) ✗ kubectl get ingresses
NAME            HOSTS       ADDRESS          PORTS   AGE
nginx-ingress   localhost   192.168.99.144   80      3m41s
➜  ft_services git:(master) ✗ kubectl apply -f ./ingress.yaml
service/nginx-svc unchanged
deployment.apps/nginx-deployment unchanged
ingress.networking.k8s.io/nginx-ingress configured
➜  ft_services git:(master) ✗ kubectl get ingresses
NAME            HOSTS                 ADDRESS          PORTS   AGE
nginx-ingress   ftservices.rchallie   192.168.99.144   80      4m
➜  ft_services git:(master) ✗ curl -kL http://ftservices.rchallie/
curl: (6) Could not resolve host: ftservices.rchallie
FROM alpine:latest

➜  ft_services git:(master) ✗ minikube ssh
echo -ne "\033[1;32m+>\033[0;33m Link folder to goinfre ...\n"
                         _             _
            _         _ ( )           ( )
  ___ ___  (_)  ___  (_)| |/')  _   _ | |_      __
/' _ ` _ `\| |/' _ `\| || , <  ( ) ( )| '_`\  /'__`\
| ( ) ( ) || || ( ) || || |\`\ | (_) || |_) )(  ___/
(_) (_) (_)(_)(_) (_)(_)(_) (_)`\___/'(_,__/'`\____)

$ su root
$ vi /etc/hosts
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
save                                                                                                                                                          113,23         54%
"save" 232L, 7147C
