#!/bin/sh

set -e

if [ -n "$FTP_USER" ]; then
	if id "$FTP_USER" &>/dev/null; then
		echo "$FTP_USER already exists."
	else
		adduser -D $FTP_USER
		echo "$FTP_USER:$FTP_PASS" | chpasswd &>/dev/null
	fi
fi

# Execute
exec $@
