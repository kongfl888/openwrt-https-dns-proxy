#!/bin/sh

git clone https://github.com/openwrt/packages.git

cp -f ./files/https-dns-proxy.config /tmp/https-dns-proxy.config

a=`md5sum ./packages/net/https-dns-proxy/files/https-dns-proxy.config|awk '{printf $1}'`

b=`cat ./.github/md5.txt`

c=0

cp -rf ./packages/net/https-dns-proxy/* ./

if [ "$a" == "$b" ];then
	cp -f /tmp/https-dns-proxy.config ./files/https-dns-proxy.config
else
	c=1
fi

md5sum ./packages/net/https-dns-proxy/files/https-dns-proxy.config|awk '{printf $1}' > ./.github/md5.txt
rm -rf ./packages/

git add .
git commit -m "Update from upstream" || echo ""

if [ $c -eq 1 ];then
	git am --ignore-whitespace  ./.github/patch/* || git am --skip
fi
