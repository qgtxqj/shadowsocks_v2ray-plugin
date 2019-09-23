#! /bin/bash

rm -rf /etc/localtime
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
date -R

SYS_Bit="$(getconf LONG_BIT)"
[[ "$SYS_Bit" == '32' ]] && BitVer='_linux_386.tar.gz'
[[ "$SYS_Bit" == '64' ]] && BitVer='_linux_amd64.tar.gz'


C_VER=`wget -qO- "https://api.github.com/repos/mholt/caddy/releases/latest" | grep 'tag_name' | cut -d\" -f4`
mkdir /caddybin
cd /caddybin
wget --no-check-certificate -qO 'caddy.tar.gz' "https://github.com/mholt/caddy/releases/download/$C_VER/caddy_$C_VER$BitVer"
tar xvf caddy.tar.gz
rm -rf caddy.tar.gz
chmod +x caddy
cd /root
mkdir /wwwroot
cd /wwwroot

wget --no-check-certificate -qO 'demo.tar.gz' "https://github.com/xianren78/v2ray-heroku/raw/master/demo.tar.gz"
tar xvf demo.tar.gz
rm -rf demo.tar.gz

cd /tmp
wget -qO v2ray-plugin-linux-amd64-v1.1.0.tar.gz https://47-164596259-gh.circle-artifacts.com/0/bin/v2ray-plugin-linux-amd64-v1.1.0-15-g5c755df.tar.gz
tar zxf v2ray-plugin-linux-amd64-v1.1.0.tar.gz
cp v2ray-plugin_linux_amd64 /usr/bin/v2ray-plugin
rm -f v2ray-plugin*

cat <<-EOF > /caddybin/Caddyfile
http://0.0.0.0:${PORT}
{
	root /wwwroot
	index index.html
	timeouts none
	proxy ${SS_Path} localhost:10001 {
		websocket
		header_upstream -Origin
	}
}
EOF


cd /caddybin
./caddy -conf="Caddyfile" &

ss-server -s 127.0.0.1 -p 10001 -k $PASSWORD -m $METHOD -t 300 -d $DNS --plugin v2ray-plugin --plugin-opts "server;path=${SS_Path}" $ARGS
