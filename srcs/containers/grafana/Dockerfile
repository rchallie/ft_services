FROM alpine:latest

RUN apk update && apk add --no-cache --upgrade bash \
&& apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/main libc6-compat

RUN wget https://dl.grafana.com/oss/release/grafana-6.6.0.linux-amd64.tar.gz \
&& tar -zxvf grafana-6.6.0.linux-amd64.tar.gz \
&& rm grafana-6.6.0/conf/defaults.ini

COPY ./defaults.ini ./grafana-6.6.0/conf/

CMD cd ./grafana-6.6.0/bin/ && ./grafana-server