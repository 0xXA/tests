#!/usr/bin/env bash

#[[ "$2" -eq "getboot" ]] && getboot=1
[[ "$1" -eq "compressnup" ]] && cmprf=1
: '
mkboot() {
	git clone -q https://github.com/osm0sis/mkbootimg.git
	cd mkbootimg && {
		make >/dev/null 2>&1
	        sudo install unpackbootimg mkbootimg /usr/local/bin
	        cd -
	}
}

ibinwalk() {
	git clone -q https://github.com/ReFirmLabs/binwalk.git
	cd binwalk && {
		./deps.sh
	        sudo python setup.py install
		cd -
	}
}

[[ getboot ]] && {
	wget $3 -O $1.zip >/dev/null 2>&1
        unzip $1.zip >/dev/null 2>&1
	if ! command -v unpackbootimg >/dev/null 2>&1; then
		mkboot
	fi
	unpackbootimg -i boot.img
	tar -cJf $1.txz boot.img-zImage
	curl -o ik https://raw.githubusercontent.com/MiCode/Xiaomi_Kernel_OpenSource/jasmine-p-oss/scripts/extract-ikconfig
	chmod +x ik && {
		./ik boot.img-zImage > a.conf
	}
}
'
#[[ cmprf ]] && {
	#tar -cJf $2.txz $2
wget https://bigota.d.miui.com/V12.0.5.0.QJOINXM/merlin_in_global_images_V12.0.5.0.QJOINXM_20201115.0000.00_10.0_in_7035a72196.tgz -O merlin.tgz
split -b 1G merlin.tgz merlin.tgz.part
telegram-upload merlin.tgz.part*
#rclone copy merlin_in_global_images_V12.0.5.0.QJOINXM_20201115.0000.00_10.0_in_7035a72196.tgz gdrive:
#}
