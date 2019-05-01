#!/bin/sh
# Generate or renew DH param, and call a hook
# Copyright 2019, Development Gateway, GPLv3+

: ${DH_BITS:=2048}
: ${NICENESS:=19}

if [ $# -lt 1 -o "$1" = '-h' -o "$1" = '--help' ]; then
	cat >&2 <<EOF
NAME
	$(basename "$0") - generate or renew DH param, and call a hook.

SYNTAX

	$(basename "$0") FILE [COMMAND] [ARG...]

OPTIONS
	FILE
		The DH param output.

	COMMAND, ARGS
		Optional hook to call, e.g. to reload the application.

ENVIRONMENT
	DH_BITS[=$DH_BITS]
		DH param size.

	NICENESS[=$NICENESS]
		Add niceness to openssl(1ssl) process.

EXAMPLE
	$(basename "$0") /etc/nginx/dh.param systemctl reload nginx
EOF
	exit
fi

TMP="$(mktemp)"
if nice -n "$NICENESS" openssl dhparam -out "$TMP" "$DH_BITS" 2>/dev/null; then
	mv -f "$TMP" "$1"
	shift
	if [ -n "$@" ]; then
		$@
	fi
fi
