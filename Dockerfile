#
# Dockerfile for ARM v6
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

# Define base image
FROM balenalib/rpi-alpine:latest

# Declare build environment variables
ENV FLICLIB_ARCH armv6l
ENV FLICLIB_VERSION 0.5
ENV VERSION 0.5.1

# Define build arguments
ARG BUILD_DATE
ARG VCS_REF

# Label image with metadata
LABEL org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.name="balena Flic" \
      org.label-schema.description="Flic smart button bridge for single-board computers." \
      org.label-schema.docker.cmd="docker run --detach --restart=unless-stopped --net=host --cap-add=NET_ADMIN --name=flic renemarc/balena-flic" \
      org.label-schema.docker.cmd.debug="docker run -it --net=host --cap-add=NET_ADMIN \$CONTAINER /bin/bash" \
      org.label-schema.docker.cmd.help="docker run -it --rm --net=host --cap-add=NET_ADMIN renemarc/balena-flic /usr/bin/flicd --help" \
      org.label-schema.vcs-ref=${VCS_REF} \
      org.label-schema.vcs-url="https://github.com/renemarc/balena-flic" \
      org.label-schema.url="https://flic.io/" \
      org.label-schema.version=${VERSION} \
      org.label-schema.schema-version="1.0"

# Start QEMU virtualization
RUN ["cross-build-start"]

# Install requirements
RUN apk add \
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
VOLUME ["/data"]

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
