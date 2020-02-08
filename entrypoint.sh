#! /bin/sh

cat <<-EOF > /etc/Caddyfile
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

/usr/sbin/caddy -conf=/etc/Caddyfile &

ss-server -s 127.0.0.1 -p 10001 -k $PASSWORD -m $METHOD -t 300 -d $DNS --plugin v2ray-plugin --plugin-opts "server;path=${SS_Path}" $ARGS
