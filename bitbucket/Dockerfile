FROM atlassian_base:latest

# https://confluence.atlassian.com/display/BitbucketServer/Bitbucket+Server+home+directory
ENV BITBUCKET_HOME      /var/atlassian/bitbucket
ENV BITBUCKET_INSTALL   /opt/atlassian/bitbucket

# Install and setup initial home directory structure.
RUN set -x \
    && addgroup -g 2002 bitbucket \
    && adduser  -u 2002 -S -G bitbucket bitbucket \
    && apk add --no-cache ca-certificates wget procps perl ttf-dejavu tini \
    && apk --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
                      --repository http://dl-cdn.alpinelinux.org/alpine/edge/community add git \
    && update-ca-certificates \
    && rm -rf      /var/lib/{apt,dpkg,cache,log}/ /tmp/* /var/tmp/* \
    && mkdir -p    "${BITBUCKET_INSTALL}" \
    && curl -L     "https://downloads.atlassian.com/software/stash/downloads/atlassian-bitbucket-5.3.2.tar.gz" \
                   | tar -xz --strip-components=1 -C "${BITBUCKET_INSTALL}" \
    && find        "${BITBUCKET_INSTALL}/app/WEB-INF/lib" -name 'postgres*.jar' -print -delete \
    && curl -L     "https://jdbc.postgresql.org/download/postgresql-42.1.4.jar" -o "${BITBUCKET_INSTALL}/app/WEB-INF/lib/postgresql.jar" \
    && chown -R    bitbucket:bitbucket ${BITBUCKET_INSTALL}/

COPY entrypoint.sh  /entrypoint.sh

VOLUME ["${BITBUCKET_HOME}"]
USER bitbucket:bitbucket

# Expose HTTP and SSH ports
EXPOSE 7990
EXPOSE 7999

WORKDIR $BITBUCKET_HOME

CMD ["/entrypoint.sh", "-fg"]
ENTRYPOINT ["/sbin/tini", "--"]

