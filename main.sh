#!/bin/bash

mkdir -p tmp
pushd tmp

curl -tsS -OL "https://raw.githubusercontent.com/IrineSistiana/mosdns/${TAG_NAME}/scripts/openwrt/mosdns-init-openwrt"
mkdir -p files/etc/init.d
mv mosdns-init-openwrt files/etc/init.d/mosdns

curl -fsS -OL "https://github.com/IrineSistiana/mosdns/releases/download/${TAG_NAME}/mosdns-linux-amd64.zip"
mkdir -p mosdns
unzip -o mosdns-linux-amd64.zip -d mosdns
mkdir -p files/usr/bin
mv mosdns/mosdns files/usr/bin/

mkdir -p files/etc/mosdns
mv mosdns/config.yaml files/etc/mosdns/

# curl -fsS -OL https://github.com/leemars/v2ray-rules-dat/releases/latest/download/geoip.dat
# curl -fsS -OL https://github.com/leemars/v2ray-rules-dat/releases/latest/download/geosite.dat
# mv {geoip,geosite}.dat files/etc/mosdns/

pushd files
sed -i 's/53/5353/g' etc/mosdns/config.yaml
chmod 755 ./usr/bin/mosdns
chmod 755 ./etc/init.d/mosdns
popd
popd

cp -rf tmp/files/* mosdns/data

sed -i "s/Version: .*/Version: ${TAG_NAME}/g" mosdns/control/control

PACKAGE_NAME="mosdns_${TAG_NAME}_x86_64.ipk"

mkdir -p package
cp -r mosdns/* package/
pushd package

pushd control
tar cvzf ../control.tar.gz ./*
popd

pushd data
tar cvzf ../data.tar.gz ./*
popd

tar cvzf "${PACKAGE_NAME}" ./control.tar.gz ./data.tar.gz ./debian-binary
export PACKAGE_OUTPUT_PATH="${PWD}/${PACKAGE_NAME}"
echo PACKAGE_OUTPUT_PATH=${PACKAGE_OUTPUT_PATH} >> $GITHUB_ENV