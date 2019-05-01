#!/bin/sh
# Generate or renew DH params, and call a hook
# Copyright 2019, Development Gateway, GPLv3+

: ${DH_BITS:=2048}
: ${NICENESS:=19}

TMP="$(mktemp)"
if nice -n "$NICENESS" openssl dhparam -out "$TMP" "$DH_BITS"; then
  mv -f "$TMP" "$1"
  shift
  if [ -n "$@" ]; then
    $@
  fi
fi
