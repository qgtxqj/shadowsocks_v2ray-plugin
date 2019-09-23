FROM debian:stretch-backports

RUN set -ex \
    && sh -c 'printf "deb http://deb.debian.org/debian stretch-backports-sloppy main" > /etc/apt/sources.list.d/stretch-backports.list' \
		&& apt-get update \
		&& apt-get install -y --no-install-recommends wget tar ca-certificates \
		&& apt-get -t stretch-backports-sloppy install -y --no-install-recommends shadowsocks-libev \
		&& rm -rf /var/lib/apt/lists/*

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
CMD /entrypoint.sh
