# Vivarium

Build OpenWrt packages using Docker and the OpenWrt SDK

## Introduction

Vivarium is a way to compile packages for
[OpenWrt](https://openwrt.org/) without having to install the necessary
[build
tools](https://openwrt.org/docs/guide-developer/build-system/install-buildsystem),
using [Docker](https://www.docker.com/).

Vivarium includes a "builder" Dockerfile for a local Docker image, based
on the CircleCI Docker image used by the [OpenWrt packages
feed](https://github.com/openwrt/packages). This local image will have
the [OpenWrt
SDK](https://openwrt.org/docs/guide-developer/using_the_sdk) set up
inside.

This also includes a Docker Compose file that holds all of the
configuration options. The Compose file also sets up a number of bind
mounts, allowing access to package source code from the Docker container
and access to build artifacts from the host machine.

## Requirements

[Docker](https://docs.docker.com/install/#supported-platforms) and
[Docker Compose](https://docs.docker.com/compose/install/) will need to
be installed.

Vivarium has only been tested with Linux (Ubuntu 19.04, to be exact).
Testing with other platforms is welcome.

## Getting started

1.  Download the source code and extract.

    If you will be using Git to manage your package source code, then
    you will want to download Vivarium as a zip or tar.gz to avoid
    nesting Git repositories.

2.  In the project directory, create a `packages` directory and add
    source code for packages, e.g. by checking out the OpenWrt packages
    feed:

        $ cd openwrt-vivarium
        $ git clone https://github.com/openwrt/packages.git

3.  If you are using Linux and your user ID is not 1000, you will need
    to change the ownership of the `packages` and `sdk` directories (and
    all files and subdirectories inside) to UID 1000, e.g.:

        $ sudo chown -R 1000:1000 packages sdk

    These directories need to be readable and writable by the normal
    user inside the Docker image (with UID 1000 / GID 1000).

4.  Build packages by using `docker-compose run`, e.g.:

        $ sudo docker-compose run --rm builder make package/python/compile V=s

    If the build was successful, the compiled package(s) will be in the
    `sdk/bin` directory.

## Configuration

All options can be found in the `docker-compose.yml` file.

### Image build options

*   `SDK_HOST`, `SDK_PATH`, `SDK_FILE`: Which SDK to use

    If there is an SDK archive (matching `SDK_FILE`) in the `sdk/sdk`
    directory, then it will be used instead of downloading the archive
    from `SDK_HOST`.

*   `BRANCH`: Which branch to use when setting up package feeds, e.g.
    `master`, `openwrt-18.06`, etc.

*   `CUSTOM_FEED`: Controls how the `packages` directory is used
    *   `n`: The directory is added as the "packages" feed, in
        place of the OpenWrt packages feed
    *   `y`: The directory is added as a custom feed (the OpenWrt
        packages feed will be present as well)

### Run-time options

*   `KEEP_SDK_FILE`: If `y`, the SDK archive within the Docker image
    will be copied to the `sdk/sdk` directory when the builder is run

*   `CONFIG_AUTOREMOVE`, `CONFIG_BUILD_LOG`: Sets the corresponding SDK
    config options (`y` or `n`)

## Rebuild local Docker image

To change SDKs or update to the latest snapshot SDK, the local Docker
image will need to be rebuilt.

If `KEEP_SDK_FILE` is `y`, it may be necessary clear the `sdk/sdk`
directory first to ensure a new SDK archive is downloaded:

    $ rm -f sdk/sdk/*

Then rebuild the image:

    $ sudo docker-compose build

The `--no-cache` option may be needed to force a rebuild / re-download.

## Directory cleaning

The SDK commands for directory cleaning (`make clean`, `make dirclean`,
etc.) are not aware of the Docker bind mounts and so may not work
correctly.

There are scripts in the `sdk` directory (`clean.sh`, `dirclean.sh`,
`distclean.sh`) that emulate the SDK commands and can be run from the
host.

## License

Copyright (C) 2019 Jeffery To  
https://github.com/jefferyto/openwrt-vivarium

Vivarium is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License version 2 as
published by the Free Software Foundation.

Vivarium is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Vivarium.  If not, see <https://www.gnu.org/licenses/>.

Contains code from .circleci/config.yml of the OpenWrt packages feed  
Copyright (C) 2018 Etienne Champetier, Ted Hess
