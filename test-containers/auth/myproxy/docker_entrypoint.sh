#!/bin/bash

set -e

if [[ -z "$1" ]]; then

  echo "Trusted server host certificate:"
  export TRUSTED_HOSTCERT=$(cat /myproxy-gateway/hostcerts/mpgcert.pem)
  echo "$TRUSTED_HOSTCERT"
  echo ""
  echo "Trusted server host key:"
  export TRUSTED_HOSTKEY=$(cat /myproxy-gateway/hostcerts/new-mpgkey.pem)
  echo "$TRUSTED_HOSTKEY"
  echo ""

fi

exec "$@"
