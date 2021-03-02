Quick and dirty attempt to create a working development environment to compile dvb drivers for
a Synology NAS and DSM 6.2.3. It only supports x86_64 (apollolake), but you can easily modify it for other architectures.

1. Clone repository and build docker image. Don't use the image available on Dockerhub. 
```bash
git clone --depth 1 https://github.com/tcamargo/dsm-media_build.git
cd dsm-media_build && make docker-image
```

2. Compile media drivers
```bash
make docker-container
make
```

4. Install
```bash
make install
```
Modules will go to /lib/modules/<kernel_version>. Just copy this directory to your Synology NAS. To avoid messing with standard modules, I copied all files to my home directory and used a script (/usr/local/etc/rc.d/modules.sh) to load the necessary modules during startup. Mind the loading order (check modules.dep) and DVB frontend drivers (see dmesg).

```bash
MODULES_DIR="/var/services/homes/camargo/media_build"
MODULES_START="kernel/drivers/media/mc/mc.ko kernel/drivers/media/dvb-frontends/tda10048.ko kernel/drivers/media/tuners/tda827x.ko kernel/drivers/media/dvb-frontends/tda10023.ko kernel/drivers/media/rc/rc-core.ko kernel/drivers/media/media.ko kernel/drivers/media/v4l2-core/videodev.ko kernel/drivers/media/common/videobuf2/videobuf2-common.ko kernel/drivers/media/common/videobuf2/videobuf2-memops.ko kernel/drivers/media/common/videobuf2/videobuf2-vmalloc.ko kernel/drivers/media/dvb-core/dvb-core.ko kernel/drivers/media/usb/dvb-usb/dvb-usb.ko kernel/drivers/media/usb/dvb-usb/dvb-usb-ttusb2.ko kernel/drivers/media/dvb-frontends/si2168.ko ./kernel/drivers/media/tuners/si2157.ko kernel/drivers/media/v4l2-core/v4l2-common.ko  kernel/drivers/media/common/tveeprom.ko kernel/drivers/media/usb/em28xx/em28xx.ko kernel/drivers/media/usb/em28xx/em28xx-dvb.ko"
MODULES_STOP=""

start_modules() {
	echo "--- Load modules ---"
	for i in $MODULES_START; do
		echo "Loading $i"
		insmod $MODULES_DIR/$i
	done }

stop_modules() {
	echo "--- Unload modules ---"
	for i in $MODULES_STOP; do
		echo "Unloading $i"
		rmmod $MODULES_DIR/$i
	done
}
case "$1" in
	start) start_modules ;;
	stop) stop_modules ;;
	*) echo "usage: $0 { start | stop }" >&2 exit 1 ;;
esac
```
If you come here looking for ways to create 3rd-party packages for Synology NAS products, I ask you to check the official documentation:
https://originhelp.synology.com/developer-guide/index.html
