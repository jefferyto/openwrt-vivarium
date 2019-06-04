#!/bin/sh -e
#
# docker-run.sh
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

#
# Contains code from .circleci/config.yml of the OpenWrt packages feed
# Copyright (C) 2018 Etienne Champetier, Ted Hess
#

cd $HOME

if [ -z "$(find / -mindepth 1 -maxdepth 1 -name "$SDK_FILE" -print -quit)" ]; then
	echo "Download the SDK"

	mkdir sdk_dl
	cd sdk_dl

	# From https://github.com/openwrt/packages/blob/master/.circleci/config.yml
	curl "https://$SDK_HOST/$SDK_PATH/sha256sums" -sS -o sha256sums
	curl "https://$SDK_HOST/$SDK_PATH/sha256sums.asc" -sS -o sha256sums.asc
	gpg --with-fingerprint --verify sha256sums.asc sha256sums
	rsync -av "$SDK_HOST::downloads/$SDK_PATH/$SDK_FILE" .
	sha256sum -c --ignore-missing sha256sums

	cd ..
	ln -s sdk_dl/$SDK_FILE ./

else
	echo "Use saved SDK"

	ln -s /$SDK_FILE ./
fi

echo "Prepare build_dir"

mkdir build_dir
cd build_dir

tar Jxf ../$SDK_FILE --strip=1

mv build_dir build_dir_default

mkdir staging_dir/target
for path in build_dir_default/target-*; do
	ln -s target staging_dir/$(basename $path)
done

echo "src-git base https://github.com/openwrt/openwrt.git;$BRANCH" > feeds.conf
if [ "$CUSTOM_FEED" = y ]; then
	echo "src-git packages https://github.com/openwrt/packages.git;$BRANCH" >> feeds.conf
	echo "src-link custom $HOME/openwrt_packages" >> feeds.conf
else
	echo "src-link packages $HOME/openwrt_packages" >> feeds.conf
fi
echo "src-git luci https://github.com/openwrt/luci.git;$BRANCH" >> feeds.conf

cat feeds.conf
