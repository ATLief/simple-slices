#!/bin/sh

prefix_num=20
for preset in neutral user server desktop; do
	preset_def="ss_preset=${preset}"
	for slice_alias in $(m4 "$@" -D "$preset_def" inc/extract-alias.m4); do
		echo "$(basename "$0"): '$*' [${preset}] -> ${slice_alias} override"
		override_dir="build/systemd/${preset}/${slice_alias}.d"
		mkdir -p "$override_dir"
		m4 "$@" -D "$preset_def" inc/slice.m4 >"${override_dir}/${prefix_num}-simple-slices.conf"
	done
	prefix_num=`expr "$prefix_num" + 10`
done
