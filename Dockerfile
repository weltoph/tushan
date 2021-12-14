FROM debian:buster
MAINTAINER Christoph Welzel <welzel@in.tum.de>

RUN set -xe \
    && DEBIAN_FRONTEND=noninteractive apt-get update -y \
    && apt-get install -y \
               --no-install-recommends \
               gprbuild \
               gnat \
               build-essential \
               libaunit18 \
               libaunit18-dev \
               gnat-gps \
               libncurses-dev \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get purge --auto-remove \
    && apt-get clean
