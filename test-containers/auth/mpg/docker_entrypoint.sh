#!/bin/bash

set -e

if [[ -z "$1" ]]; then

  echo "MyProxy Gateway host cert:"
  export TRUSTED_HOSTCERT=$(cat /myproxy-gateway/hostcerts/mpgcert.pem)
  echo "$TRUSTED_HOSTCERT"
  echo ""
  echo "MyProxy Gateway host key:"
  export TRUSTED_HOSTKEY=$(cat /myproxy-gateway/hostcerts/new-mpgkey.pem)
  echo "$TRUSTED_HOSTKEY"
  echo ""

fi

exec "$@"
