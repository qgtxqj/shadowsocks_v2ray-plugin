FROM alpine:latest

RUN apk --update add --no-cache caddy ca-certificates libcrypto1.1 libev libsodium mbedtls pcre c-ares \
    && rm -rf /etc/localtime \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && mkdir /wwwroot \
    && cd /wwwroot \
    && wget --no-check-certificate -qO 'demo.tar.gz' "https://github.com/xianren78/v2ray-heroku/raw/master/demo.tar.gz" \
    && wget http://atl.lg.virmach.com/100MB.test \
    && tar xvf demo.tar.gz \
    && rm -rf demo.tar.gz \
    && cd /tmp \
    && wget -qO v2ray-plugin-linux-amd64.tar.gz https://87-164596259-gh.circle-artifacts.com/0/bin/v2ray-plugin-linux-amd64-v1.3.1-4-g63a74be.tar.gz \
    && tar zxf v2ray-plugin-linux-amd64.tar.gz \
    && cp v2ray-plugin_linux_amd64 /usr/bin/v2ray-plugin \
    && rm -f v2ray-plugin* \
    && wget --no-check-certificate -qO 'shadowsocks.tar.xz' https://github.com/shadowsocks/shadowsocks-rust/releases/download/v1.8.13/shadowsocks-v1.8.13.x86_64-unknown-linux-gnu.tar.xz \
    && tar -xvJf shadowsocks.tar.xz \
    && cp ssserver /usr/bin/ss-server \
    && chmod +x /usr/bin/ss-server \
    && rm -rf shadowsocks.tar.xz \
    && rm -rf ss*

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
CMD /entrypoint.sh
