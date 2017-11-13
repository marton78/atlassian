# Build git-lfs from source
FROM atlassian_base:latest
RUN set -x \
    && apk add --no-cache libc-dev make  \
    && apk --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.6/community add git go \
    && cd /root \
    && curl -Ls https://github.com/git-lfs/git-lfs/archive/v2.3.4.tar.gz | tar -xz --strip-components=1 --no-same-owner \
    && script/bootstrap


# Bamboo
FROM atlassian_base:latest

COPY --from=0 /root/bin/git-lfs /usr/local/bin

# Configuration variables.
ENV BAMBOO_HOME     /var/atlassian/bamboo
ENV BAMBOO_INSTALL  /opt/atlassian/bamboo

# Install and setup initial home directory structure.
RUN set -x \
    && apk --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.6/community add git \
    && git lfs install \
    && addgroup -g 2003 bamboo \
    && adduser  -u 2003 -S -G bamboo bamboo \
    && mkdir -p               "${BAMBOO_HOME}/lib" \
    && chmod -R 700           "${BAMBOO_HOME}" \
    && chown -R bamboo:bamboo "${BAMBOO_HOME}" \
    && mkdir -p               "${BAMBOO_INSTALL}" \
    && curl -L                "https://www.atlassian.com/software/bamboo/downloads/binary/atlassian-bamboo-6.2.2.tar.gz" | tar -zx --directory  "${BAMBOO_INSTALL}" --strip-components=1 --no-same-owner \
    && find                    "${BAMBOO_INSTALL}/lib" -name 'postgres*.jar' -print -delete \
    && curl -L                 "https://jdbc.postgresql.org/download/postgresql-42.1.4.jar" -o "${BAMBOO_INSTALL}/lib/postgresql.jar" \
    && chmod -R 700           "${BAMBOO_INSTALL}" \
    && chown -R bamboo:bamboo "${BAMBOO_INSTALL}" \
    && sed --in-place         's/^# umask 0027$/umask 0027/g' "${BAMBOO_INSTALL}/bin/setenv.sh" \
    && xmlstarlet             ed --inplace \
        --delete              "Server/Service/Engine/Host/@xmlValidation" \
        --delete              "Server/Service/Engine/Host/@xmlNamespaceAware" \
                              "${BAMBOO_INSTALL}/conf/server.xml" \
    && touch -d "@0"          "${BAMBOO_INSTALL}/conf/server.xml"

# Use the default unprivileged account. This could be considered bad practice
# on systems where multiple processes end up being executed by 'daemon' but
# here we only ever run one process anyway.
USER bamboo:bamboo

# Expose default HTTP and SSH ports.
EXPOSE 8085 54663

# Set volume mount points for installation and home directory. Changes to the
# home directory needs to be persisted as well as parts of the installation
# directory due to eg. logs.
VOLUME ["/var/atlassian/bamboo","/opt/atlassian/bamboo/logs"]

# Set the default working directory as the Bamboo home directory.
WORKDIR /var/atlassian/bamboo

COPY "docker-entrypoint.sh" "/"
ENTRYPOINT ["/docker-entrypoint.sh"]

# Run Atlassian Bamboo as a foreground process by default.
CMD ["/opt/atlassian/bamboo/bin/start-bamboo.sh", "-fg"]

