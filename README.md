This repository contains configuration files for building a 
[Docker](http://docker.io) image for the Airsonic media streamer.

## Noteworthy

* [Airsonic](http://airsonic.org/) (latest version)
* [Debian](https://debian.org/) (latest stable)
* Runs as normal user (UID 10000)
* Checks upstream OpenPGP signatures

This was created because no other Docker build had those properties at
the time. The [official Docker image](https://github.com/airsonic/airsonic/blob/master/install/docker/Dockerfile), for example, runs as root
and builds on top of Alpine instead.

## Build your own image

```shell
$ docker build -t <your-name>/debian-airsonic debian-airsonic
```

## Get a pre-built image

A current image is available as a trusted build from the Docker index:

```shell
$ docker pull anarcat/debian-airsonic
```

The Docker repository page is at:

https://hub.docker.com/r/anarcat/debian-airsonic/

## Run a container with this image

```shell
$ docker run \
  --detach \
  --publish 8080:8080 \
  --volume "/wherever/your/music/is:/var/music:ro" \
  <your-name>/debian-airsonic
```

Arguments passed to `docker run` will be passed as-is on the
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

The host music directory mounted into the container at `/var/music` must be
readable by user airsonic (UID 10000).

If you use a volume for the container's `/var/airsonic`, the host directory
mounted there must have read-write-execute permissions for user
airsonic (UID 10000).
