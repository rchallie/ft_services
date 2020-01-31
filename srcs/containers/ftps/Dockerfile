FROM alpine:latest

# install vsftpd
RUN apk update && apk add vsftpd && apk add openrc --no-cache

RUN mkdir /srv/ftp

RUN tee /etc/vsftpd/vsftpd.conf listen=YES local_enable=YES xferlog_enable=YES connect_from_port_20=YES pam_service_name=vsftpd seccomp_sandbox=NO write_enable=YES secure_chroot_dir=/var/empty anonymous_enable=YES anon_root=/srv/ftp no_anon_password=YES 

RUN mkdir /srv/ftp && chown nobody:nogroup /srv/ftp \
&& echo "anon" | sudo tee /srv/ftp/anon.txt

# RUN rc-service vsftpd start \
# && rc-update add vsftpd

CMD rc-service vsftpd start && rc-update add vsftpd