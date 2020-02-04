FROM alpine:latest

RUN apk update && apk add influxdb \
&& apk add --no-cache --upgrade bash

# RUN echo "CREATE DATABASE db_grafana" | influx

CMD influxd run -config /etc/influxdb.conf