#!/bin/zsh

BOLD='\033[1;33m'
CLEAR='\033[0m'
echo -e ""$BOLD"TEST SETUP$CLEAR"

export TAG_NAME=v3.5.2
export GITHUB_ENV=/dev/null
export GITHUB_WORKSPACE="$(realpath .)/workspace"

export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"

echo "PATH:"
echo -e "$BOLD$PATH$CLEAR"

rm -rf "$GITHUB_WORKSPACE"
mkdir -p "$GITHUB_WORKSPACE"
cp -r {mosdns,main.sh} "$GITHUB_WORKSPACE"
find "$GITHUB_WORKSPACE" -name ".DS_Store" -delete

echo -e ""$BOLD"TEST BEGIN$CLEAR"
cd "$GITHUB_WORKSPACE"
./main.sh