# openwrt-mosdns

Openwrt x86_64 .ipk package of [IrineSistiana/mosdns](https://github.com/IrineSistiana/mosdns).

## Install

```sh
# export OPENWRT_MOSDNS_INSTALL_CDN=<your cdn address>
wget -O - "${OPENWRT_MOSDNS_INSTALL_CDN:+${OPENWRT_MOSDNS_INSTALL_CDN}"/"}\
https://raw.githubusercontent.com/fangqiuming/openwrt-mosdns/main/install.sh" | sh
```