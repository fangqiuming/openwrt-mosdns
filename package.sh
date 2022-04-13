#!/bin/sh

set -eu

IPK_FILE_NAME="${PACKAGE_NAME}_${TAG_NAME}_${DISTRIB_ARCH}.ipk"

mkdir -p tmp/package
cp -r mosdns/* tmp/package/
cd tmp/package

cd control
tar cvzf ../control.tar.gz ./*
cd ..

cd data
tar cvzf ../data.tar.gz ./*
cd ..

tar cvzf "${IPK_FILE_NAME}" ./control.tar.gz ./data.tar.gz ./debian-binary
export PACKAGE_OUTPUT_PATH="${PWD}/${IPK_FILE_NAME}"
echo PACKAGE_OUTPUT_PATH=${PACKAGE_OUTPUT_PATH} >> $GITHUB_ENV