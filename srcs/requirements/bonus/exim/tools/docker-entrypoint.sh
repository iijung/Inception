#!/bin/sh

set -e

if [ -n "$EXIM_USER" ]; then
	if id "$EXIM_USER" &>/dev/null; then
		echo "$EXIM_USER already exists."
	else
		adduser -u 1000 -D $EXIM_USER
		addgroup $EXIM_USER exim
		echo "$EXIM_USER:$EXIM_PASS" | chpasswd &>/dev/null
	fi
fi

# Execute
exec $@
