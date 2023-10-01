#!/bin/sh -e
#
# docker-entrypoint.sh
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

container=$(echo "$CONTAINER" | tr '/' '-')
tag=$(echo "$TAG" | tr '/' '-')

setup_dir() {
	local dir="$1"
	local path
	local name

	mkdir -p "$dir"
	for path in "${dir}_default"/*; do
		name="${path##*/}"
		if [ ! -e "$dir/${name}_${container}_$tag" ]; then
			cp -pr "$path" "$dir/${name}_${container}_$tag"
		fi
		ln -fsT "${name}_${container}_$tag" "$dir/$name"
	done
}

setup_dir bin
setup_dir build_dir
setup_dir staging_dir

for path in staging_dir_working/host staging_dir_working/toolchain-*; do
	name="${path##*/}"
	if [ ! -e "staging_dir/$name" ]; then
		ln -s "../staging_dir_working/$name" "staging_dir/$name"
	fi
done

cp feeds.conf.default feeds.conf
if [ "$USE_GITHUB_FEEDS" = y ]; then
	sed \
		-e 's,https://git.openwrt.org/feed/,https://github.com/openwrt/,' \
		-e 's,https://git.openwrt.org/openwrt/,https://github.com/openwrt/,' \
		-e 's,https://git.openwrt.org/project/,https://github.com/openwrt/,' \
		-i feeds.conf
fi
echo "src-link vivarium /vivarium/packages" >> feeds.conf

mkdir -p logs

cp -f feeds.conf logs/feeds.conf
./scripts/feeds update -a
./scripts/feeds install -a

if [ -d /vivarium/overrides ]; then
	cp -fpr /vivarium/overrides/. ./
fi

if [ ! -e .config ]; then
	touch .config

	if [ "$CONFIG_AUTOREMOVE" = y ]; then
		echo "CONFIG_AUTOREMOVE=y" >> .config
	else
		echo "# CONFIG_AUTOREMOVE is not set" >> .config
	fi

	if [ "$CONFIG_BUILD_LOG" = y ]; then
		echo "CONFIG_BUILD_LOG=y" >> .config
	else
		echo "# CONFIG_BUILD_LOG is not set" >> .config
	fi

	if [ -f diffconfig ]; then
		cat diffconfig >> .config
	fi
fi

make defconfig
cp -f .config logs/config

if [ "$#" -gt 0 ]; then
	"$@"
fi
