FROM debian:bullseye
MAINTAINER Christoph Welzel <welzel@in.tum.de>

RUN set -xe \
    && DEBIAN_FRONTEND=noninteractive apt-get update -y \
    && apt-get install -y \
               --no-install-recommends \
               gprbuild \
               gnat \
               build-essential \
               libaunit20 \
               libaunit20-dev \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get purge --auto-remove \
    && apt-get clean
