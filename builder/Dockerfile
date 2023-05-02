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

ARG CONTAINER
ARG TAG

FROM $CONTAINER:$TAG

ARG CONTAINER
ARG TAG

ENV CONTAINER=$CONTAINER
ENV TAG=$TAG

COPY builder/. /vivarium/

RUN sh -e /vivarium/docker-run.sh

ENTRYPOINT [ "sh", "-e", "/vivarium/docker-entrypoint.sh" ]
