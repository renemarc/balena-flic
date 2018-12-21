#
# Alpine Dockerfile for ARM
#
# This file will be used on non balenaCloud/openBalena environments, like local
# balenaEngine/Docker builds or Docker Hub.
#
# Based on the Home Assistant addon by @pschmitt:
# https://github.com/pschmitt/hassio-addons/blob/master/flicd/Dockerfile
#
# Available base images:
# https://www.balena.io/docs/reference/base-images/base-images/
#

# Declare pre-build variables
ARG ARCH_NAME=rpi

# Define base image
FROM balenalib/${ARCH_NAME}-alpine:latest

# Declare build variables
ARG ARCH_NAME
ARG BUILD_DATE=1970-01-01T00:00:00Z
ARG FLICLIB_ARCH=unknown
ARG FLICLIB_VERSION=0.5
ARG VCS_REF=0000000
ARG VERSION=0.5.3

# Label image with metadata
LABEL org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.description="Flic smart button bridge for single-board computers." \
      org.label-schema.docker.cmd="docker run --detach --restart=unless-stopped --net=host --cap-add=NET_ADMIN --name=flic renemarc/balena-flic" \
      org.label-schema.docker.cmd.debug="docker run -it --net=host --cap-add=NET_ADMIN flic bash" \
      org.label-schema.docker.cmd.help="docker run -it --rm --net=host --cap-add=NET_ADMIN renemarc/balena-flic flicd --help" \
      org.label-schema.name="balena Flic" \
      org.label-schema.url="https://flic.io/" \
      org.label-schema.vcs-ref=${VCS_REF} \
      org.label-schema.vcs-url="https://github.com/renemarc/balena-flic" \
      org.label-schema.version=${VERSION} \
      org.label-schema.schema-version="1.0"

# Start QEMU virtualization
RUN ["cross-build-start"]

# Install requirements
RUN case ${ARCH_NAME} in \
      aarch64|armv7hf|rpi) export FLICLIB_ARCH=armv6l ;; \
      amd64) export FLICLIB_ARCH=x86_64 ;; \
      i386) export FLICLIB_ARCH=i386 ;; \
    esac \
 && apk add \
      g++ \
      git \
      libc6-compat \
      libstdc++ \
      make \
 && git clone --branch ${FLICLIB_VERSION} --depth 1 \
      https://github.com/50ButtonsEach/fliclib-linux-hci /tmp/src \
 && make --directory=/tmp/src/simpleclient \
 && cp /tmp/src/simpleclient/simpleclient /usr/bin/ \
 && cp /tmp/src/bin/${FLICLIB_ARCH}/flicd /usr/bin/ \
 && chmod +x /usr/bin/flicd \
 && apk del \
      g++ \
      git \
      make \
 && rm -rf \
      /tmp/src

# Setup application directory
WORKDIR /data

# Create a volume to store the database
VOLUME [ "/data" ]

# Listen to Flic service TCP port
EXPOSE 5551

# Start Flic daemon
CMD [ "/usr/bin/flicd", \
      "--db-file", "/data/flic.sqlite", \
      "--server-addr", "0.0.0.0", \
      "--server-port", "5551" \
    ]

# Complete QEMU virtualization
RUN ["cross-build-end"]
