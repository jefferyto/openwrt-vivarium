#!/bin/sh -e
#
# docker-run.sh
# This file is part of Vivarium.
#
# Copyright (C) 2019, 2022-2023 Jeffery To
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

mkdir -p bin_default/packages bin_default/targets

mkdir -p build_dir/hostpkg
mv build_dir build_dir_default

mkdir staging_dir_default
mkdir -p staging_dir/hostpkg
mv staging_dir staging_dir_working
for path in staging_dir_working/hostpkg staging_dir_working/target-*; do
	mv "$path" staging_dir_default/
	ln -s "../staging_dir/${path##*/}" "$path"
done
