#!/bin/sh

set -eu

BOLD='\e[1;33m'
COLOR='\e[0;33m'
CLEAR='\e[0m'
printf "%bTEST SETUP%b\n" "${BOLD}" "${CLEAR}"

export TAG_NAME=v3.5.2
export PACKAGE_NAME=mosdns
export DISTRIB_ARCH=x86_64
export GITHUB_ENV=/dev/stdout
GITHUB_WORKSPACE="$(realpath .)/workspace"
export GITHUB_WORKSPACE

export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:${PATH}"

echo "PATH:"
printf "  %b%b%b\n" "${COLOR}" "${PATH}" "${CLEAR}"

rm -rf "${GITHUB_WORKSPACE}"
mkdir -p "${GITHUB_WORKSPACE}"
cp -r .gitignore mosdns collect.sh package.sh "${GITHUB_WORKSPACE}"
find "${GITHUB_WORKSPACE}" -name ".DS_Store" -delete

printf "%bTEST BEGIN%b\n" "${BOLD}" "${CLEAR}"
cd "$GITHUB_WORKSPACE"
git init -q
git add -A
git commit -q -m "Test begin"
printf "%bRUN COLLECT FILE SCRIPT%b\n" "${COLOR}" "${CLEAR}"
./collect.sh
printf "%bCHECK FILE%b\n" "${COLOR}" "${CLEAR}"
git add mosdns/*
if test "$(git status -s | wc -l)" -gt 0; then
  git commit -q -m "Auto update for mosdns ${TAG_NAME}"
  git log --name-status HEAD^..HEAD
else
  echo 'Nothing to commit'
fi
printf "%bRUN PACKAGE .IPK SCRIPT%b\n" "${COLOR}" "${CLEAR}"
. ./package.sh
printf "%bTEST END%b\n" "${BOLD}" "${CLEAR}"
printf "Release:\n"
printf "  name: %b\n" "${TAG_NAME}"
printf "  tag_name: %b\n" "${TAG_NAME}"
printf "  body: Openwrt x86_64 .ipk package of mosdns %b(https://github.com/IrineSistiana/mosdns/releases/tag/%b)\n" "${TAG_NAME}" "${TAG_NAME}"
printf "  files: %b\n" "${PACKAGE_OUTPUT_PATH}"
