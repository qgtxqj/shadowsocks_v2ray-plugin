# Dockerfile for shadowsocks-libev based alpine 
# Reference URL: 
# https://github.com/shadowsocks/shadowsocks-libev 
# https://shadowsocks.be/12.html

FROM debian:stretch-backports

RUN set -ex \
		&& apt-get update \
		&& apt-get install -y --no-install-recommends wget tar ca-certificates \
		&& apt-get -t stretch-backports install -y --no-install-recommends shadowsocks-libev \
		&& rm -rf /var/lib/apt/lists/*

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
CMD /entrypoint.sh

