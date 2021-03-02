build: media_build
	@export CROSS_COMPILE=/usr/local/x86_64-pc-linux-gnu/bin/x86_64-pc-linux-gnu-
	@for p in patches/*; do \
		patch -d media_build -p 1 -i ../$$p; \
	done
	@cd media_build; make release DIR=/usr/local/x86_64-pc-linux-gnu/x86_64-pc-linux-gnu/sys-root/usr/lib/modules/DSM-6.2/build
	@cd media_build; ./build

media_build:
	@git clone --depth 5 git://linuxtv.org/media_build.git

clean:
	@rm -rf media_build

docker-image:
	@docker build -t discworld/dsm-media_build .

docker-container:
	@docker run --rm -it -v $$(pwd)/../dsm-media_build:/dsm-media_build discworld/dsm-media_build