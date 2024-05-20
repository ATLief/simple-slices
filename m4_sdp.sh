#!/bin/sh
set -e
parent_path_orig="$1"
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
for preset_iter in neutral user server desktop util; do
	parent_path="${parent_path_orig}/${preset_iter}"
	if $is_override; then
		parent_path="${parent_path}/${child_name_orig}"
		child_name="${override_num}-simple-slices.conf"
	else
		child_name="$child_name_orig"
	fi
	m4_args="-D ss_preset=${preset_iter} -D ss_name=${unit_name}"
	if m4 $m4_args "$@" inc/assert-whitelist.m4 >/dev/null; then
		echo "$(basename "$0"): [${preset_iter}] ${child_name_orig}"
		mkdir -p "$parent_path"
		m4 $m4_args "$@" >"${parent_path}/${child_name}"
	else
		ecode=$?
		if [ "$ecode" -lt 100 -o "$ecode" -gt 200 ]; then
			exit "$ecode"
		fi
	fi
	override_num=`expr "$override_num" + 10`
done
