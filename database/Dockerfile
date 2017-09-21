FROM postgres:9.6-alpine

VOLUME ["/root/backup"]

RUN apk add --no-cache git
COPY backup restore /usr/local/bin/
COPY init_cron.sh /docker-entrypoint-initdb.d/

