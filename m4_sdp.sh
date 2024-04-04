#!/bin/sh
set -e
preset="$1"
child_name="$2"
override_num="$3"
shift 3
parent_path="build/systemd/${preset}"
if [ "$(echo "$child_name" | rev | cut -d . -f 1)" = "d" ]; then
	parent_path="${parent_path}/${child_name}"
	child_name="${override_num}-simple-slices.conf"
fi
mkdir -p "$parent_path"
m4 -D "ss_preset=${preset}" "$@" >"${parent_path}/${child_name}"
