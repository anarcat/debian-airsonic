FROM debian:stretch

MAINTAINER michael@schuerig.de

ENV DEBIAN_FRONTEND noninteractive

# Create a new user account with UID/GID at least 10000.
# This makes it easier to keep host and docker accounts apart.
RUN useradd --home /var/airsonic -M airsonic -K UID_MIN=10000 -K GID_MIN=10000 && \
    mkdir -p /var/airsonic && chown airsonic /var/airsonic && chmod 0770 /var/airsonic

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

ENV VERSION 10.0.0

# Download and setup airsonic
RUN rm -rf /usr/local/tomcat/webapps ; mkdir -p /usr/local/tomcat/webapps

ADD https://github.com/airsonic/airsonic/releases/download/v$VERSION/airsonic.war /usr/local/tomcat/webapps/ROOT.war

RUN chmod a+r /usr/local/tomcat/webapps/ROOT.war ; mkdir -p /var/airsonic/transcode && ln -s /usr/bin/flac /usr/bin/lame /usr/bin/ffmpeg /var/airsonic/transcode

VOLUME /var/airsonic

EXPOSE 4040

USER airsonic

ENTRYPOINT ["/usr/bin/java", \
     "-Djava.awt.headless=true", \
     "-jar", \
     "/usr/local/tomcat/webapps/ROOT.war"]`
