#!/bin/sh
set -e
preset_arg="$1"
child_name="$2"
shift 2
parent_path="build/systemd/${preset_arg}"
if [ "$(echo "$child_name" | rev | cut -d . -f 1)" = "d" ]; then
	override_num=20
	for preset_iter in neutral user server desktop; do
		if [ "$preset_iter" = "$preset_arg" ]; then
			parent_path="${parent_path}/${child_name}"
			child_name="${override_num}-simple-slices.conf"
		fi
		override_num=`expr "$override_num" + 10`
	done
fi
mkdir -p "$parent_path"
m4 -D "ss_preset=${preset_arg}" "$@" >"${parent_path}/${child_name}"
