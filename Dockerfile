FROM debian:stretch-backports

RUN set -ex \
    && sh -c 'printf "deb http://deb.debian.org/debian stretch-backports-sloppy main" > /etc/apt/sources.list.d/stretch-backports.list' \
		&& apt-get update \
		&& apt-get install -y --no-install-recommends wget tar ca-certificates curl \
		&& apt-get -t stretch-backports-sloppy install -y --no-install-recommends shadowsocks-libev \
		&& rm -rf /var/lib/apt/lists/* \
		&& curl https://getcaddy.com | bash -s personal tls.dns.cloudflare \
		&& mkdir /wwwroot \
    && cd /wwwroot \
    && wget --no-check-certificate -qO 'demo.tar.gz' "https://github.com/xianren78/v2ray-heroku/raw/master/demo.tar.gz" \
    && tar xvf demo.tar.gz \
    && rm -rf demo.tar.gz \
    && cd /tmp \
    && wget -qO v2ray-plugin-linux-amd64-v1.2.0.tar.gz https://66-164596259-gh.circle-artifacts.com/0/bin/v2ray-plugin-linux-amd64-v1.2.0-9-g32b3eea.tar.gz \
    && tar zxf v2ray-plugin-linux-amd64-v1.2.0.tar.gz \
    && cp v2ray-plugin_linux_amd64 /usr/bin/v2ray-plugin \
    && rm -f v2ray-plugin* \
    && rm -rf /etc/localtime \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
CMD /entrypoint.sh
