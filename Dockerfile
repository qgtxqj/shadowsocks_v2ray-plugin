FROM alpine:latest

#GIT
ENV SS_GIT_PATH="https://github.com/shadowsocks/shadowsocks-libev"

#Download applications
RUN apk --update add --no-cache caddy ca-certificates libcrypto1.1 libev libsodium mbedtls pcre c-ares \
&& rm -rf /etc/localtime \
&& ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
&& apk add --no-cache --virtual TMP git autoconf automake make build-base zlib-dev gettext-dev asciidoc xmlto libpcre32 libev-dev \
libsodium-dev libtool linux-headers mbedtls-dev openssl-dev pcre-dev c-ares-dev g++ gcc \

#Compile Shadowsocks
&& cd /tmp \
&& git clone ${SS_GIT_PATH} \
&& cd ${SS_GIT_PATH##*/} \
&& git submodule update --init --recursive \
&& ./autogen.sh \
&& ./configure --prefix=/usr && make \
&& make install \
&& apk del TMP \
&& rm -rf /tmp/* \
&& rm -rf /var/cache/apk/* \
&& mkdir /wwwroot \
    && cd /wwwroot \
    && wget --no-check-certificate -qO 'demo.tar.gz' "https://github.com/xianren78/v2ray-heroku/raw/master/demo.tar.gz" \
    && tar xvf demo.tar.gz \
    && rm -rf demo.tar.gz \
    && cd /tmp \
    && wget -qO v2ray-plugin-linux-amd64-v1.2.0.tar.gz https://66-164596259-gh.circle-artifacts.com/0/bin/v2ray-plugin-linux-amd64-v1.2.0-9-g32b3eea.tar.gz \
    && tar zxf v2ray-plugin-linux-amd64-v1.2.0.tar.gz \
    && cp v2ray-plugin_linux_amd64 /usr/bin/v2ray-plugin \
    && rm -f v2ray-plugin*

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
CMD /entrypoint.sh
