FROM alpine:3.6

VOLUME ["/root/backup"]

RUN apk --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/main add postgresql git \
    && echo "0 4 * * * backup 'scheduled update'" | crontab -
COPY backup restore /usr/local/bin/
CMD ["/usr/sbin/crond", "-f", "-l", "1"]

