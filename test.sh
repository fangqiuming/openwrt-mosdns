#!/bin/zsh

set -eu

BOLD='\033[1;33m'
COLOR='\033[0;33m'
CLEAR='\033[0m'
echo -e "${BOLD}TEST SETUP${CLEAR}"

export TAG_NAME=v3.5.2
export PACKAGE_NAME=mosdns
export DISTRIB_ARCH=x86_64
export GITHUB_ENV=/dev/stdout
export GITHUB_WORKSPACE="$(realpath .)/workspace"

export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:${PATH}"

echo "PATH:"
echo -e "  ${COLOR}${PATH}${CLEAR}"

rm -rf "${GITHUB_WORKSPACE}"
mkdir -p "${GITHUB_WORKSPACE}"
cp -r {.gitignore,mosdns,collect.sh,package.sh} "${GITHUB_WORKSPACE}"
find "${GITHUB_WORKSPACE}" -name ".DS_Store" -delete

echo -e "${BOLD}TEST BEGIN${CLEAR}"
cd "$GITHUB_WORKSPACE"
git init -q; git add -A; git commit -q -m "Test begin"
echo -e "${COLOR}RUN COLLECT FILE SCRIPT${CLEAR}"
./collect.sh
echo -e "${COLOR}CHECK FILE${CLEAR}"
git add mosdns/*
if [[ $(git status -s | wc -l) -gt 0 ]]; then
  git commit -q -m "Auto update for mosdns ${TAG_NAME}"
  git log --name-status HEAD^..HEAD
else
  echo 'Nothing to commit'
fi
echo -e "${COLOR}RUN PACKAGE .IPK SCRIPT${CLEAR}"
. ./package.sh
echo -e "${BOLD}TEST END$CLEAR"
echo "Release:"
echo "  name: ${TAG_NAME}"
echo "  tag_name: ${TAG_NAME}"
echo "  body: Openwrt x86_64 .ipk package of mosdns ${TAG_NAME}(https://github.com/IrineSistiana/mosdns/releases/tag/${TAG_NAME})"
echo "  files: ${PACKAGE_OUTPUT_PATH}"