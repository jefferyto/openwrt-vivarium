#
# Dockerfile
# This file is part of Vivarium.
#
# Copyright (C) 2019 Jeffery To
# https://github.com/jefferyto/openwrt-vivarium
#
# Vivarium is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 as
# published by the Free Software Foundation.
#
# Vivarium is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Vivarium.  If not, see <https://www.gnu.org/licenses/>.
#

FROM docker.io/openwrtorg/packages-cci:v1.0.2

ARG SDK_HOST
ARG SDK_PATH
ARG SDK_FILE
ARG BRANCH
ARG CUSTOM_FEED

ENV SDK_HOST=$SDK_HOST
ENV SDK_PATH=$SDK_PATH
ENV SDK_FILE=$SDK_FILE
ENV BRANCH=$BRANCH
ENV CUSTOM_FEED=$CUSTOM_FEED

WORKDIR /home/build

COPY builder/docker-run.sh sdk/sdk/$SDK_FILE /

RUN sh -e /docker-run.sh

COPY builder/docker-entrypoint.sh /

ENTRYPOINT [ "sh", "-e", "/docker-entrypoint.sh" ]
