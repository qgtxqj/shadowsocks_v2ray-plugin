FROM heroku/heroku:16

RUN apt update -y \
    && apt upgrade -y \
    && apt install -y wget unzip qrencode bsdmainutils openssh-server openssh-sftp-server curl bash python bash nano vim net-tools xz \
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
    && ls -lh /usr/bin/ss* \
    && ls -lh /usr/bin/v2* \
    && rm -rf shadowsocks.tar.xz \
    && rm -rf ss* \
    && mkdir /caddybin  \  	
    && cd /caddybin   \  	
    && wget --no-check-certificate -qO 'caddy.tar.gz' https://github.com/caddyserver/caddy/releases/download/v1.0.4/caddy_v1.0.4_linux_amd64.tar.gz  \  	
    && tar xvf caddy.tar.gz  \  	
    && rm -rf caddy.tar.gz   \  	
    && chmod +x caddy	
ADD ./authorized_keys /etc/ssh/authorized_keys
RUN chmod 600 /etc/ssh/authorized_keys
ADD ./sshd_config /etc/ssh/sshd_config
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ADD ./.profile.d /app/.profile.d
CMD  bash /app/.profile.d/heroku-exec.sh