FROM atlassian_base:latest

# Configuration variables.
ENV CONF_HOME     /var/atlassian/confluence
ENV CONF_INSTALL  /opt/atlassian/confluence

# Install and setup initial home directory structure.
RUN set -x \
    && apk --no-cache add      "graphviz" \
    && addgroup -g 2001 conf \
    && adduser  -u 2001 -S -G conf conf \
    && mkdir -p                "${CONF_HOME}" \
    && chmod -R 700            "${CONF_HOME}" \
    && chown -R conf:conf      "${CONF_HOME}" \
    && mkdir -p                "${CONF_INSTALL}/conf/Catalina" \
    && curl -L                 "https://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-6.6.3.tar.gz" | tar -xz --directory "${CONF_INSTALL}" --strip-components=1 --no-same-owner \
    && find                    "${CONF_INSTALL}/confluence/WEB-INF/lib" -name 'postgres*.jar' -print -delete \
    && curl -L                 "https://jdbc.postgresql.org/download/postgresql-42.2.2.jar" -o "${CONF_INSTALL}/confluence/WEB-INF/lib/postgresql.jar" \
    && chmod -R 700            "${CONF_INSTALL}/conf" \
    && chmod -R 700            "${CONF_INSTALL}/logs" \
    && chmod -R 700            "${CONF_INSTALL}/temp" \
    && chmod -R 700            "${CONF_INSTALL}/work" \
    && chown -R conf:conf      "${CONF_INSTALL}/conf" \
    && chown -R conf:conf      "${CONF_INSTALL}/logs" \
    && chown -R conf:conf      "${CONF_INSTALL}/temp" \
    && chown -R conf:conf      "${CONF_INSTALL}/work" \
    && echo -e                 "\nconfluence.home=$CONF_HOME" >> "${CONF_INSTALL}/confluence/WEB-INF/classes/confluence-init.properties" \
    && xmlstarlet              ed --inplace \
        --delete               "Server/@debug" \
        --delete               "Server/Service/Connector/@debug" \
        --delete               "Server/Service/Connector/@useURIValidationHack" \
        --delete               "Server/Service/Connector/@minProcessors" \
        --delete               "Server/Service/Connector/@maxProcessors" \
        --delete               "Server/Service/Engine/@debug" \
        --delete               "Server/Service/Engine/Host/@debug" \
        --delete               "Server/Service/Engine/Host/Context/@debug" \
        --insert               "Server/Service" -t elem -n 'Listener className="org.apache.catalina.core.AprLifecycleListener" SSLEngine="on"' \
                               "${CONF_INSTALL}/conf/server.xml" \
    && touch -d "@0"           "${CONF_INSTALL}/conf/server.xml"

# Disable the 'Remember Me' feature in Confluence
# https://confluence.atlassian.com/confkb/how-to-disable-the-remember-me-feature-in-confluence-118686062.html
#
# Disable Autocomplete Password in Browser for Confluence
# https://community.atlassian.com/t5/Confluence-questions/Need-to-disable-Autocomplete-Password-in-Browser-for-Confluence/qaq-p/110523
RUN sed -i '/remember.accesskey/d' ${CONF_INSTALL}/confluence/login.vm \
    && sed -i 's/"name='\''os_password'\''"/"name='\''os_password'\''" "autocomplete='\''off'\''"/g' ${CONF_INSTALL}/confluence/login.vm \
    && sed -i 's/<session-timeout>60<\/session-timeout>/<session-timeout>10<\/session-timeout>/g' ${CONF_INSTALL}/confluence/WEB-INF/web.xml


# Use a specified service account
USER conf:conf

# Expose default HTTP connector port.
EXPOSE 8090
EXPOSE 8091

# Set volume mount points for installation and home directory. Changes to the
# home directory needs to be persisted as well as parts of the installation
# directory due to eg. logs.
VOLUME ["/var/atlassian/confluence", "/opt/atlassian/confluence/logs"]

# Set the default working directory as the installation directory.
WORKDIR /var/atlassian/confluence

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

# Run Atlassian Confluence as a foreground process by default.
CMD ["/opt/atlassian/confluence/bin/catalina.sh", "run"]
