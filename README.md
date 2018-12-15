# 🔘 Flic smart button bridge

[![GitHub Release][img-release]][link-release] [![Flic SDK Version][img-flic-sdk]][link-flic-sdk] [![Travis CI][img-travis]][link-travis] [![GitHub][img-repo]][link-repo] [![balena][img-balena]][link-balena] [![Tweet][img-twitter]][link-twitter]

Turn a [Raspberry Pi](https://www.raspberrypi.org/) or many single-board computers into a plug-in appliance to bridge your Bluetooth [Flic smart buttons](https://flic.io/) to your home automation system of choice, like [Home Assistant](https://www.home-assistant.io/).

- ARM images are based on [Alpine Linux](https://alpinelinux.org/about/) while the x86 ones are based on [Debian](https://www.debian.org/), and their [sizes are kept to a minimum](https://hub.docker.com/r/renemarc/balena-flic/tags/). ⚖️
- [Container labels](http://label-schema.org/rc1/) metadata can be [explored on MicroBadger](https://microbadger.com/images/renemarc/balena-flic). 🔍
- Images and Dockerfiles are provided on a best-effort basis; should you find tweaks and improvements, do [open a pull request](https://github.com/renemarc/balena-flic/pulls)! 😃

While this project repo's content is optimized for [balena](https://www.balena.io/what-is-balena), the images and Dockerfiles can be used in [many supported ARM, x86_64 and i386 Docker environments](https://hub.docker.com/r/renemarc/balena-flic/tags/), as long as Bluetooth Low Energy and network access are provided.

## Usage instructions ℹ️

Run the following commands on your linux-running host:

### Start the daemon

```sh
docker run --detach --restart=unless-stopped \
    --net=host --cap-add=NET_ADMIN --name=flic \
    renemarc/balena-flic
```

### Explore the above container

```sh
docker logs flic
```

```sh
docker exec -it flic /bin/bash
```

### Play with a temporary container

```sh
docker kill flic
```

```sh
docker run -it --rm --net=host --cap-add=NET_ADMIN \
    renemarc/balena-flic /bin/bash
```

[See complete usage instructions on GitHub](https://github.com/renemarc/balena-flic). 👀

## Supported tags and respective `Dockerfile` links 🔖

- `latest` (multi-platform)
- [`aarch64`, `armv7hf`, `rpi` (*Dockerfile*)](https://github.com/renemarc/balena-flic/blob/master/Dockerfile)
- [`amd64`, `i386` (*Dockerfile-debian.Dockerfile*)](https://github.com/renemarc/balena-flic/blob/master/Dockerfile-debian.Dockerfile)

The **latest** tag is a [multi-platform aware manifest list](https://blog.docker.com/2017/09/docker-official-images-now-multi-platform/), and is [created/updated on Travis CI](https://travis-ci.org/renemarc/balena-flic) using [this shell script](https://github.com/renemarc/balena-flic/blob/master/manifest.sh).

[Architecture-specific tags](https://hub.docker.com/r/renemarc/balena-flic/tags/) are automated builds, with their base images swapped at build-time using a [post_checkout Docker hook](https://github.com/renemarc/balena-flic/blob/master/hooks/post_checkout).

## Automated build pipeline 🏗

![build pipeline](https://raw.githubusercontent.com/renemarc/balena-flic/master/.github/build-pipeline.png)

Images are automatically built and kept up to date using the following steps:

1. **GitHub ➡️Docker**

    [Architecture-specific](https://hub.docker.com/r/renemarc/balena-flic/tags/) images are automatically built by Docker Hub:
    1. on Git pushes to [GitHub](https://github.com/renemarc/balena-flic).
    2. when their underlying base images are updated.
2. **Docker ➡️dockerhub2ci**

    Upon automatic image creation, Docker Hub sends a webhook notice to an instance of [dockerhub2ci](https://github.com/somleng/dockerhub2ci) hosted on [Heroku](https://heroku.com/deploy).
3. **dockerhub2ci ➡️Travis CI**

    dockerhub2ci then sends a properly-formatted query to [Travis CI](https://travis-ci.org/renemarc/balena-flic) to start the build of a [multi-platform aware manifest list](https://blog.docker.com/2017/09/docker-official-images-now-multi-platform/).
4. **Travis CI ➡️Docker**

    Travis CI builds, tests and pushes the manifest [latest](https://hub.docker.com/r/renemarc/balena-flic/tags/) tag to Docker Hub using [this shell script](https://github.com/renemarc/balena-flic/blob/master/manifest.sh).

[img-balena]:https://img.shields.io/badge/built_on-balena-goldenrod.svg?logo=data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz48IURPQ1RZUEUgc3ZnIFBVQkxJQyAiLS8vVzNDLy9EVEQgU1ZHIDEuMS8vRU4iICJodHRwOi8vd3d3LnczLm9yZy9HcmFwaGljcy9TVkcvMS4xL0RURC9zdmcxMS5kdGQiPjxzdmcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayIgdmVyc2lvbj0iMS4xIiB3aWR0aD0iMjQiIGhlaWdodD0iMjQiIHZpZXdCb3g9IjAgMCAyNCAyNCI+PHBhdGggZD0iTTEyLDUuMzJMMTgsOC42OVYxNS4zMUwxMiwxOC42OEw2LDE1LjMxVjguNjlMMTIsNS4zMk0yMSwxNi41QzIxLDE2Ljg4IDIwLjc5LDE3LjIxIDIwLjQ3LDE3LjM4TDEyLjU3LDIxLjgyQzEyLjQxLDIxLjk0IDEyLjIxLDIyIDEyLDIyQzExLjc5LDIyIDExLjU5LDIxLjk0IDExLjQzLDIxLjgyTDMuNTMsMTcuMzhDMy4yMSwxNy4yMSAzLDE2Ljg4IDMsMTYuNVY3LjVDMyw3LjEyIDMuMjEsNi43OSAzLjUzLDYuNjJMMTEuNDMsMi4xOEMxMS41OSwyLjA2IDExLjc5LDIgMTIsMkMxMi4yMSwyIDEyLjQxLDIuMDYgMTIuNTcsMi4xOEwyMC40Nyw2LjYyQzIwLjc5LDYuNzkgMjEsNy4xMiAyMSw3LjVWMTYuNU0xMiw0LjE1TDUsOC4wOVYxNS45MUwxMiwxOS44NUwxOSwxNS45MVY4LjA5TDEyLDQuMTVaIiBmaWxsPSIjZmZmZmZmIiAvPjwvc3ZnPgo=&maxAge=86400
[img-flic-sdk]:https://img.shields.io/badge/uses_Flic_SDK-0.5-blue.svg?logo=data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz48IURPQ1RZUEUgc3ZnIFBVQkxJQyAiLS8vVzNDLy9EVEQgU1ZHIDEuMS8vRU4iICJodHRwOi8vd3d3LnczLm9yZy9HcmFwaGljcy9TVkcvMS4xL0RURC9zdmcxMS5kdGQiPjxzdmcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayIgdmVyc2lvbj0iMS4xIiB3aWR0aD0iMjQiIGhlaWdodD0iMjQiIHZpZXdCb3g9IjAgMCAyNCAyNCI+PHBhdGggZD0iTTEyLDIwQTgsOCAwIDAsMSA0LDEyQTgsOCAwIDAsMSAxMiw0QTgsOCAwIDAsMSAyMCwxMkE4LDggMCAwLDEgMTIsMjBNMTIsMkExMCwxMCAwIDAsMCAyLDEyQTEwLDEwIDAgMCwwIDEyLDIyQTEwLDEwIDAgMCwwIDIyLDEyQTEwLDEwIDAgMCwwIDEyLDJNMTIsN0E1LDUgMCAwLDAgNywxMkE1LDUgMCAwLDAgMTIsMTdBNSw1IDAgMCwwIDE3LDEyQTUsNSAwIDAsMCAxMiw3WiIgZmlsbD0iI2ZmZmZmZiIgLz48L3N2Zz4K&maxAge=21600
[img-release]:https://img.shields.io/github/release/renemarc/balena-flic/all.svg?logo=data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz48IURPQ1RZUEUgc3ZnIFBVQkxJQyAiLS8vVzNDLy9EVEQgU1ZHIDEuMS8vRU4iICJodHRwOi8vd3d3LnczLm9yZy9HcmFwaGljcy9TVkcvMS4xL0RURC9zdmcxMS5kdGQiPjxzdmcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayIgdmVyc2lvbj0iMS4xIiB3aWR0aD0iMjQiIGhlaWdodD0iMjQiIHZpZXdCb3g9IjAgMCAyNCAyNCI+PHBhdGggZD0iTTIuNiwxMC41OUw4LjM4LDQuOEwxMC4wNyw2LjVDOS44Myw3LjM1IDEwLjIyLDguMjggMTEsOC43M1YxNC4yN0MxMC40LDE0LjYxIDEwLDE1LjI2IDEwLDE2QTIsMiAwIDAsMCAxMiwxOEEyLDIgMCAwLDAgMTQsMTZDMTQsMTUuMjYgMTMuNiwxNC42MSAxMywxNC4yN1Y5LjQxTDE1LjA3LDExLjVDMTUsMTEuNjUgMTUsMTEuODIgMTUsMTJBMiwyIDAgMCwwIDE3LDE0QTIsMiAwIDAsMCAxOSwxMkEyLDIgMCAwLDAgMTcsMTBDMTYuODIsMTAgMTYuNjUsMTAgMTYuNSwxMC4wN0wxMy45Myw3LjVDMTQuMTksNi41NyAxMy43MSw1LjU1IDEyLjc4LDUuMTZDMTIuMzUsNSAxMS45LDQuOTYgMTEuNSw1LjA3TDkuOCwzLjM4TDEwLjU5LDIuNkMxMS4zNywxLjgxIDEyLjYzLDEuODEgMTMuNDEsMi42TDIxLjQsMTAuNTlDMjIuMTksMTEuMzcgMjIuMTksMTIuNjMgMjEuNCwxMy40MUwxMy40MSwyMS40QzEyLjYzLDIyLjE5IDExLjM3LDIyLjE5IDEwLjU5LDIxLjRMMi42LDEzLjQxQzEuODEsMTIuNjMgMS44MSwxMS4zNyAyLjYsMTAuNTlaIiBmaWxsPSIjZmZmZmZmIi8+PC9zdmc+Cg==&maxAge=21600
[img-repo]:https://img.shields.io/badge/fork_me_on-GitHub-green.svg?logo=github&logoColor=white&maxAge=21600
[img-travis]:https://img.shields.io/travis/renemarc/balena-flic.svg?logo=travis&label=manifest%20build
[img-twitter]:https://img.shields.io/twitter/url/http/shields.io.svg?style=social&maxAge=86400

[link-balena]:https://www.balena.io/cloud/
[link-flic-sdk]:https://github.com/50ButtonsEach/fliclib-linux-hci/releases
[link-release]:https://github.com/renemarc/balena-flic/releases
[link-repo]:https://github.com/renemarc/balena-flic/
[link-travis]:https://travis-ci.org/renemarc/balena-flic
[link-twitter]:https://twitter.com/intent/tweet?text=Flic%20smart%20button%20bridge%3A%20a%20balena%20and%20Docker%20container&url=https://github.com/renemarc/balena-flic&via=renemarc&hashtags=Flic,balena,Docker,RaspberryPi,IoT,HomeAssistant,SmartHome
