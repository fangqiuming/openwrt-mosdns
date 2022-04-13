#!/bin/sh

set -eu

: <<'END'
What do this script do?
[Openwrt General Installation Tutorial](https://github.com/IrineSistiana/mosdns/wiki/Home/da51e5d807fb83c862a4dabe802f9b7e5be339d2#openwrt-%E5%AE%89%E8%A3%85%E9%80%9A%E7%94%A8%E6%95%99%E7%A8%8B)
END

mkdir -p tmp/collect
cd tmp/collect

SOURCE_URL='https://raw.githubusercontent.com/IrineSistiana/mosdns'
curl -OL "${SOURCE_URL}/${TAG_NAME}/scripts/openwrt/mosdns-init-openwrt"
mkdir -p files/etc/init.d
mv mosdns-init-openwrt files/etc/init.d/mosdns

case "${DISTRIB_ARCH}" in
x86_64) CORE_ARCH="linux-amd64" ;;
esac
SOURCE_URL="https://github.com/IrineSistiana/mosdns/releases/download"
curl -OL "${SOURCE_URL}/${TAG_NAME}/mosdns-${CORE_ARCH}.zip"
mkdir -p mosdns
unzip -o "mosdns-${CORE_ARCH}.zip" -d mosdns
mkdir -p files/usr/bin
mv mosdns/mosdns files/usr/bin/

mkdir -p files/etc/mosdns
mv mosdns/config.yaml files/etc/mosdns/

# curl -fsS -OL https://github.com/leemars/v2ray-rules-dat/releases/latest/download/geoip.dat
# curl -fsS -OL https://github.com/leemars/v2ray-rules-dat/releases/latest/download/geosite.dat
# mv {geoip,geosite}.dat files/etc/mosdns/

cd files
sed -i 's/53/5353/g' etc/mosdns/config.yaml
chmod 755 ./usr/bin/mosdns
chmod 755 ./etc/init.d/mosdns
cd ../../..

cp -rf tmp/collect/files/* mosdns/data

sed -i "s/Version: .*/Version: ${TAG_NAME}/g" mosdns/control/control
