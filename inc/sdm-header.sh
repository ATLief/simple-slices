#!/bin/sh
set -e
if [ "$(id -u)" -gt 0 ]; then
	systemd_mode="--user"
else
	systemd_mode="--system"
fi
