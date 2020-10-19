# SPDX-License-Identifier: GPL-2.0
obj-m += cr14.o

all:
	make -C /lib/modules/$(shell uname -r)/build M=$(shell pwd) modules

clean:
	make -C /lib/modules/$(shell uname -r)/build M=$(shell pwd) clean

cr14.dtbo:
	dtc -I dts -O dtb -o cr14.dtbo cr14-overlay.dts

install: cr14.ko cr14.dtbo
	install -o root -m 755 -d /lib/modules/$(shell uname -r)/kernel/input/misc/
	install -o root -m 644 cr14.ko /lib/modules/$(shell uname -r)/kernel/input/misc/
	depmod -a $(shell uname -r)
	install -o root -m 644 cr14.dtbo /boot/overlay-user/
	sed /boot/armbianEnv.txt -i -e "s/^#dtparam=i2c_arm=on/dtparam=i2c_arm=on/"
	grep -q -E "^dtparam=i2c_arm=on" /boot/armbianEnv.txt || printf "dtparam=i2c_arm=on\n" >> /boot/armbianEnv.txt
	sed /boot/armbianEnv.txt -i -e "s/^#dtoverlay=cr14/dtoverlay=cr14/"
	grep -q -E "^dtoverlay=cr14" /boot/armbianEnv.txt || printf "dtoverlay=cr14\n" >> /boot/armbianEnv.txt

.PHONY: all clean install
