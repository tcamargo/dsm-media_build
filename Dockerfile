FROM debian:buster-slim

ENV PACKAGES \
	build-essential \
	git \
	kmod \
	libproc-processtable-perl \
	patchutils \
	python \

	vim \
	wget

RUN apt-get update && apt-get install -y ${PACKAGES} && rm -rf /var/lib/apt/lists/*

RUN wget --content-disposition https://sourceforge.net/projects/dsgpl/files/Tool%20Chain/DSM%206.2.3%20Tool%20Chains/Intel%20x86%20Linux%204.4.59%20%28Apollolake%29/apollolake-gcc493_glibc220_linaro_x86_64-GPL.txz/download && \
	tar xvfJ apollolake-gcc493_glibc220_linaro_x86_64-GPL.txz -C /usr/local && \
	rm apollolake-gcc493_glibc220_linaro_x86_64-GPL.txz

RUN wget --content-disposition https://sourceforge.net/projects/dsgpl/files/toolkit/DSM6.2/ds.apollolake-6.2.dev.txz/download && \
	tar xvfJ ds.apollolake-6.2.dev.txz -C / && \
	rm ds.apollolake-6.2.dev.txz

RUN mkdir /build
COPY Makefile /build
ADD patches /build/patches

WORKDIR /build

ENTRYPOINT [ "/bin/bash" ]
