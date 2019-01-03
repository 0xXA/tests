#!/usr/bin/env bash

[[ "$2" -eq "getboot" ]] && getboot=1

[[ getboot ]] && {
	wget $3 -O $1.zip >/dev/null 2>&1
        unzip $2.zip >/dev/null 2>&1
	if ! command -v unpackbootimg >/dev/null 2>&1; then
		boottools
	fi
	unpackbootimg -i boot.img
	tar -cJf $1.txz boot.img-zImage
}

boottools() {
	git clone -q https://github.com/osm0sis/mkbootimg.git
	cd mkbootimg && {
		sudo make install
	        cd -
	}
}