#!/usr/bin/env bash
set -ex

# Init global variables.
FXHOME=${FXHOME:-$HOME/.fxcore}
FXNET=${FXNET:-testnet}

# Init local variables.
fxcore_path_config=$FXHOME/config
fxcore_path_config_examples=$FXHOME/config-$FXNET
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

# Initialize node if required.
if [ ! -f "${fxcore_path_config}"/node_key.json ]; then
  /usr/bin/fxcored init fx-zakir --overwrite --chain-id fx-zakir
  /usr/bin/cosmovisor init /usr/bin/fxcored
fi

# Copy config files.
cp -uv "${fxcore_path_config_examples}"/*.* "${fxcore_path_config}"/

# Extract data files from the snapshot.
if [ -n "$FXSNAPURL" ] && [ "$(wc -w < <(echo "${fxcore_path_data}"/*.db))" -lt 5 ]; then
  __curl "$FXSNAPURL" | tar -f- --skip-old-files -vxz -C "${fxcore_path_data}"/..
fi

# Start.
/usr/bin/cosmovisor run start --x-crisis-skip-assert-invariants
