#!/bin/sh
set -e
preset_arg="$1"
child_name="$2"
shift 2
unit_name="$child_name"
parent_path="build/systemd/${preset_arg}"
if [ "$(echo "$child_name" | rev | cut -d . -f 1)" = "d" ]; then
	override_num=20
	unit_name="$(echo "$unit_name" | rev | cut -c 3- | rev)"
	for preset_iter in neutral user server desktop; do
		if [ "$preset_iter" = "$preset_arg" ]; then
			parent_path="${parent_path}/${child_name}"
			child_name="${override_num}-simple-slices.conf"
		fi
		override_num=`expr "$override_num" + 10`
	done
fi
m4_args="-D ss_preset=${preset_arg} -D ss_name=${unit_name}"
if m4 $m4_args "$@" >/dev/null; then
	mkdir -p "$parent_path"
	m4 $m4_args "$@" >"${parent_path}/${child_name}"
fi
