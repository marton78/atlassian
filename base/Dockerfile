# Image for building Tomcat Native
FROM anapsix/alpine-java:8_jdk_unlimited
RUN apk add --no-cache openssl-dev apr-dev libc-dev gcc make curl tar \
    && curl -L http://archive.apache.org/dist/tomcat/tomcat-connectors/native/1.2.16/source/tomcat-native-1.2.16-src.tar.gz \
     | tar -xz --directory ~ --strip-components=1 --no-same-owner \
    && cd ~/native \
    && ./configure && make \
    && cp .libs/libtcnative-1.so.0.2.16 /libtcnative-1.so

# Atlassian base image 
FROM anapsix/alpine-java:8_server-jre_unlimited
RUN set -x \
    && apk --no-cache add coreutils sed bash curl tar apr openssl xmlstarlet
COPY --from=0 /libtcnative-1.so /usr/lib
