# FROM Image : alpine
FROM alpine:latest

# Install telegraf for monitoring
RUN mkdir /etc/telegraf \
&& wget https://dl.influxdata.com/telegraf/releases/telegraf-1.13.3-static_linux_amd64.tar.gz \
&& tar -C . -xzf telegraf-1.13.3-static_linux_amd64.tar.gz \
&& chmod +x telegraf/* \
&& cp telegraf/telegraf /usr/bin/ \
&& rm -rf *.tar.gz* telegraf/ \
&& rm -rf /var/cache/apk/*

COPY telegraf.conf /etc/telegraf/telegraf.conf
COPY setup.sh .

RUN chmod +x setup.sh

EXPOSE 4999

CMD ./setup.sh