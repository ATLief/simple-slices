#!/bin/sh
set -e
if [ "$1" = "configure" ] || [ "$1" = "remove" ]; then
	if [ -d /run/systemd/system ]; then
		systemctl --system daemon-reload >/dev/null || true
	fi
fi

#DEBHELPER#

exit 0
