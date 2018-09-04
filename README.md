This repository contains configuration files for building a 
Docker (http://docker.io) image for the Airsonic media streamer.

## Noteworthy

* Airsonic (http://airsonic.org/ - latest version)
* Debian (https://debian.org/ - latest stable)
* Runs as normal user (UID 10000)

## Build your own image

```shell
$ docker build -t <your-name>/debian-airsonic debian-airsonic
```

## Get a pre-built image

A current image is available as a trusted build from the Docker index:

```shell
$ docker pull  mschuerig/debian-airsonic
```

The repository page is at
https://hub.docker.com/r/mschuerig/subsonic-docker-image/


## Run a container with this image

```shell
$ docker run \
  --detach \
  --publish 8080:8080 \
  --volume "/wherever/your/music/is:/var/music:ro" \
  <your-name>/debian-airsonic
```

Arguments passed to `docker run` will be passed as-is to the
Airsonic commandline, see the upstream [configuration guide](https://airsonic.github.io/docs/configure/standalone/) for
more information about available options. For example,
to [enable TLS](https://docs.spring.io/spring-boot/docs/1.4.5.RELEASE/reference/htmlsingle/#production-ready-management-specific-ssl), you could do:

```shell
$ docker run \
  --detach \
  --publish 4040:4040 \
  --volume "/wherever/your/music/is:/var/music:ro" \
  <your-name>/debian-airsonic \
  -Dserver.ssl.enabled=true \
  [...]
```

## Pitfalls

The host music directory mounted into the container at /var/music must be
readable by user airsonic (UID 10000).

If you use a volume for the container's /var/airsonic, the host directory
mounted there must have read-write-execute permissions for user
airsonic (UID 10000).
