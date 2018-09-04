FROM debian:stretch

MAINTAINER anarcat@debian.org

ENV DEBIAN_FRONTEND noninteractive
ENV SONIC_USER airsonic
ENV SONIC_DIR /var/airsonic

# Create a new user account with UID/GID at least 10000.
# This makes it easier to keep host and docker accounts apart.
RUN useradd --home "$SONIC_DIR" -M "$SONIC_USER" -K UID_MIN=10000 -K GID_MIN=10000 && \
    mkdir -p "$SONIC_DIR" && chown "$SONIC_USER" "$SONIC_DIR" && chmod 0770 "$SONIC_DIR"

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    apt-get update && \
    apt-get dist-upgrade --yes --no-install-recommends --no-install-suggests && \
    apt-get install --yes --no-install-recommends --no-install-suggests \
            openjdk-8-jre-headless \
            locales \
            flac \
            lame \
            ffmpeg \
            curl \
            && \
    apt-get clean

ENV LC_ALL en_US.UTF-8

# Download and setup airsonic
RUN rm -rf /usr/local/tomcat/webapps ; mkdir -p /usr/local/tomcat/webapps

COPY keyring.gpg /usr/local/tomcat/webapps/keyring.gpg

RUN curl -SL -o /usr/local/tomcat/webapps/ROOT.war https://github.com/airsonic/airsonic/releases/download/v10.1.2/airsonic.war
RUN curl -SL -o /usr/local/tomcat/webapps/ROOT.war.asc https://github.com/airsonic/airsonic/releases/download/v10.1.2/airsonic.war.asc

RUN gpgv --keyring /usr/local/tomcat/webapps/keyring.gpg /usr/local/tomcat/webapps/ROOT.war.asc /usr/local/tomcat/webapps/ROOT.war

RUN chmod a+r /usr/local/tomcat/webapps/ROOT.war ; mkdir -p "$SONIC_DIR"/transcode && ln -s /usr/bin/flac /usr/bin/lame /usr/bin/ffmpeg "$SONIC_DIR"/transcode

VOLUME "$SONIC_DIR"

EXPOSE 8080

USER "$SONIC_USER"

ENTRYPOINT ["/usr/bin/java", \
     "-Djava.awt.headless=true", \
     "-jar", \
     "/usr/local/tomcat/webapps/ROOT.war"]`
