FROM alpine:3.6

VOLUME ["/root/backup"]

RUN apk update \
    && apk add git postgresql-client \
    && rm -rf /var/cache/apk/* \
    && echo "0 4 * * * backup 'scheduled update'" | crontab -
COPY backup restore /usr/local/bin/
CMD ["/usr/sbin/crond", "-f", "-l", "1"]

