#!/bin/sh

set -eu

REDIRECTION="https://github.com/fangqiuming/openwrt-mosdns/releases/latest"
DOWNLOAD_URL="https://github.com/fangqiuming/openwrt-mosdns/releases/download"
if [ -n "${OPENWRT_MOSDNS_INSTALL_CDN}" ]; then
  REDIRECTION="${OPENWRT_MOSDNS_INSTALL_CDN}/${REDIRECTION}"
  DOWNLOAD_URL="${OPENWRT_MOSDNS_INSTALL_CDN}/${DOWNLOAD_URL}"
fi

(
  set -x
  REDIRECTION=$(wget "${REDIRECTION}" --server-response -O /dev/null 2>&1 |
    awk '/^  Location: /{DEST=$2} END {print DEST}')
  TAG_NAME=${REDIRECTION##*/}
  FILE_NAME="mosdns_${TAG_NAME}_x86_64.ipk"
  wget -q --show-progress -O "${FILE_NAME}" \
    "${DOWNLOAD_URL}/${TAG_NAME}/${FILE_NAME}"
  opkg install "${FILE_NAME}"
)
