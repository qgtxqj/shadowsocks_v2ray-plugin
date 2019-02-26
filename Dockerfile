# Dockerfile for shadowsocks-libev based alpine 
# Reference URL: 
# https://github.com/shadowsocks/shadowsocks-libev 
# https://shadowsocks.be/12.html

FROM debian:stretch-backports

RUN set -ex \
		&& apt-get update \
		&& apt-get install -y --no-install-recommends wget tar ca-certificates \
		&& apt-get -t stretch-backports install -y --no-install-recommends shadowsocks-libev \
		&& cd /tmp \
		&& wget -qO v2ray-plugin-linux-amd64-v1.1.0.tar.gz https://github.com/shadowsocks/v2ray-plugin/releases/download/v1.1.0/v2ray-plugin-linux-amd64-v1.1.0.tar.gz \
		&& tar zxf v2ray-plugin-linux-amd64-v1.1.0.tar.gz \
		&& cp v2ray-plugin_linux_amd64 /usr/bin/v2ray-plugin \
		&& rm -f v2ray-plugin* \
		&& rm -rf /var/lib/apt/lists/*

USER nobody 

CMD ss-server -s 0.0.0.0 -p $PORT -k $PASSWORD -m $METHOD -t 300 -d $DNS --plugin v2ray-plugin --plugin-opts "server" $ARGS
