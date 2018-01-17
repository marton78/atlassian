FROM alpine:latest

RUN apk add --no-cache apache2 apache2-utils apache2-webdav apache2-ldap mod_dav_svn subversion \
    && mkdir /run/apache2

VOLUME [ "/var/svn" ]
EXPOSE 80 443
ADD run.sh /

CMD ["/run.sh"]

