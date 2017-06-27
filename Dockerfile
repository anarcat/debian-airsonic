FROM debian:stretch

MAINTAINER michael@schuerig.de

ENV DEBIAN_FRONTEND noninteractive

# Create a new user account with UID/GID at least 10000.
# This makes it easier to keep host and docker accounts apart.
RUN useradd --home /var/libresonic -M libresonic -K UID_MIN=10000 -K GID_MIN=10000 && \
    mkdir -p /var/libresonic && chown libresonic /var/libresonic && chmod 0770 /var/libresonic

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    apt-get update && \
    apt-get dist-upgrade --yes --no-install-recommends --no-install-suggests && \
    apt-get install --yes --no-install-recommends --no-install-suggests \
            openjdk-8-jre-headless \
            locales \
            flac \
            lame \
            ffmpeg \
            && \
    apt-get clean

ENV LIBRESONIC_VERSION 6.2

# Download and setup libresonic
RUN rm -rf /usr/local/tomcat/webapps ; mkdir -p /usr/local/tomcat/webapps

ADD https://libresonic.org/release/libresonic-v$LIBRESONIC_VERSION.war /usr/local/tomcat/webapps/ROOT.war

RUN chmod a+r /usr/local/tomcat/webapps/ROOT.war ; mkdir -p /var/libresonic/transcode && ln -s /usr/bin/flac /usr/bin/lame /usr/bin/ffmpeg /var/libresonic/transcode

VOLUME /var/libresonic

EXPOSE 4040

USER libresonic

ENTRYPOINT ["/usr/bin/java", \
     "-Djava.awt.headless=true", \
     "-jar", \
     "/usr/local/tomcat/webapps/ROOT.war"]`
