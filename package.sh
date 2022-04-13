#!/bin/sh

IPK_FILE_NAME="${PACKAGE_NAME}_${TAG_NAME}_${DISTRIB_ARCH}.ipk"

mkdir -p tmp/package
cp -r mosdns/* tmp/package/
pushd tmp/package

pushd control
tar cvzf ../control.tar.gz ./*
popd

pushd data
tar cvzf ../data.tar.gz ./*
popd

tar cvzf "${IPK_FILE_NAME}" ./control.tar.gz ./data.tar.gz ./debian-binary
export PACKAGE_OUTPUT_PATH="${PWD}/${IPK_FILE_NAME}"
echo PACKAGE_OUTPUT_PATH=${PACKAGE_OUTPUT_PATH} >> $GITHUB_ENV