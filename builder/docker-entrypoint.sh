#!/bin/sh -e
#
# docker-entrypoint.sh
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

mkdir -p build_dir
for path in build_dir_default/*; do
	if [ ! -e "build_dir/${path##*/}" ]; then
		cp -pr "$path" build_dir/
	fi
done

mkdir -p staging_dir/hostpkg
for path in staging_dir_default/*; do
	if [ ! -e "staging_dir/${path##*/}" ]; then
		cp -pr "$path" staging_dir/
	fi
done
for path in staging_dir_working/host staging_dir_working/toolchain-*; do
	if [ ! -e "staging_dir/${path##*/}" ]; then
		ln -s "../staging_dir_working/${path##*/}" "staging_dir/${path##*/}"
	fi
done

sed -i \
	-e "/\s*config AUTOREMOVE$/{n;n;s/default [yn]/default ${CONFIG_AUTOREMOVE:-y}/}" \
	-e "/\s*config BUILD_LOG$/{n;n;s/default [yn]/default ${CONFIG_BUILD_LOG:-n}/}" \
	Config.in

if [ -d /vivarium/overrides ] && [ -n "$(find /vivarium/overrides -mindepth 1 -maxdepth 1 \! -path '*/.*' -name '*' -print -quit)" ]; then
	cp -fpr /vivarium/overrides/* ./
fi

./scripts/feeds update -a
./scripts/feeds install -a

if [ -f diffconfig ]; then
	cp -f diffconfig .config
fi

make defconfig

mkdir -p logs
cp -f .config logs/config

if [ "$#" -gt 0 ]; then
	"$@"
fi
