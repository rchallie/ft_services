FROM alpine:latest

# update && install nginx && bash && openssl && folder for nginx pid
RUN apk update && apk add nginx \
&& apk add --no-cache --upgrade bash \
&& apk add openssl && mkdir -p var/run/nginx \
&& apk add openssl openssh \
&& rm -rf /var/cache/apk/*

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
COPY id_rsa_key_ssh /etc/ssh/ssh_host_rsa_key
COPY sshd_config /etc/ssh/

COPY setup.sh .

RUN chmod +x setup.sh
RUN chmod 600 /etc/ssh/ssh_host_rsa_key

EXPOSE 1234 80 443
CMD ./setup.sh
