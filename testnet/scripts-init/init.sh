#!/usr/bin/env bash
set -e

# Init global variables.
FXHOME=${FXHOME:-$HOME/.fxcore}
FXSNAPURL=${FXSNAPURL:-https://fx-testnet.s3.amazonaws.com/fxcore-snapshot-2021-11-15.tar.gz}

# Init local variables.
fxcore_path_config=$FXHOME/config
fxcore_path_config_examples=$FXHOME/config-testnet
fxcore_path_data=$FXHOME/data

# Define local functions.
# @see: https://unix.stackexchange.com/a/421318/21471
function __curl() {
  read -r _ server path < <(echo "${1//// }")
  DOC=/${path// //}
  HOST=${server//:*/}
  PORT=${server//*:/}
  [[ "${HOST}" == "${PORT}" ]] && PORT=80

  exec 3<>/dev/tcp/"${HOST}/$PORT"
  echo -en "GET ${DOC} HTTP/1.0\r\nHost: ${HOST}\r\n\r\n" >&3
  (while read -r line; do
    [[ "$line" == $'\r' ]] && break
  done && cat) <&3
  exec 3>&-
}

# Copy config files.
cp -v "${fxcore_path_config_examples}"/*.* "${fxcore_path_config}"/

# Extract data files from the snapshot.
__curl "$FXSNAPURL" | tar vxzf - -C "${fxcore_path_data}"/..
