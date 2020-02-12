FROM alpine:latest

RUN apk upgrade && \
    printf '%s\n' \
      '@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing' \
      >> /etc/apk/repositories && \
    apk update && \
	apk add openssl && \
    apk add pure-ftpd@testing="1.0.49-r0" && \
    rm -rf /var/cache/apk/*

COPY setup.sh .

RUN chmod +x setup.sh

EXPOSE 21 21000

CMD ./setup.sh