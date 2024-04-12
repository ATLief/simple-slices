#!/bin/sh
set -e
preset_arg="$1"
child_name_orig="$2"
shift 2
override_num=20
if [ "$(echo "$child_name_orig" | rev | cut -d . -f 1)" = "d" ]; then
	is_override=true
	unit_name="$(echo "$child_name_orig" | rev | cut -c 3- | rev)"
else
	is_override=false
	unit_name="$child_name_orig"
fi
for preset_iter in neutral user server desktop; do
	parent_path="build/systemd/${preset_arg}"
	if $is_override; then
		parent_path="${parent_path}/${child_name_orig}"
		child_name="${override_num}-simple-slices.conf"
	else
		child_name="$child_name_orig"
	fi
	m4_args="-D ss_preset=${preset_arg} -D ss_name=${unit_name}"
	if [ "$preset_iter" = "$preset_arg" ]; then
		if m4 $m4_args "$@" >/dev/null; then
			mkdir -p "$parent_path"
			m4 $m4_args "$@" >"${parent_path}/${child_name}"
		fi
	fi
	override_num=`expr "$override_num" + 10`
done
