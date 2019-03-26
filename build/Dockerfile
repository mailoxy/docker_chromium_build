FROM debian:9

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get --assume-yes install \
       openjdk-8-jdk \
       git-core \
       gnupg \
       flex \
       bison \
       build-essential \
       zip \
       curl \
       zlib1g-dev \
       gcc-multilib \
       g++-multilib \
       libc6-dev-i386 \
       lib32ncurses5-dev \
       x11proto-core-dev \
       libx11-dev \
       lib32z-dev \
       ccache \
       libgl1-mesa-dev \
       xsltproc \
       unzip \
       python-networkx \
       liblz4-tool \
       jq \
       gawk \
       gradle \
       bc \
       gperf \
       fuseext2 \
       libxml2-dev \
       cutils \
       android-libcutils-dev \
       m4 \
       wget \
       lsb-release \
       sudo \
       locales

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG='en_US.UTF-8'
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

RUN useradd -G sudo debian --uid 1000 -s /bin/bash \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
    && mkdir /home/debian \
    && chown debian.debian /home/debian

RUN cd /opt && rm -rf depot_tools; git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git && chown -R debian /opt/depot_tools

RUN curl https://storage.googleapis.com/git-repo-downloads/repo > /usr/local/bin/repo && chmod a+x /usr/local/bin/repo

ENV PATH /opt/depot_tools:${PATH}

USER debian

