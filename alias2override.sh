#!/bin/sh

for mode in system user; do
	mode_def="ss_is_${mode}=true"
	for slice_alias in $(m4 -I inc -D "$mode_def" "$@" inc/extract-alias.m4); do
		echo "$(basename "$0"): '$*' [${mode}] -> ${slice_alias} override"
		override_dir="build/systemd/${mode}/${slice_alias}.d"
		mkdir -p "$override_dir"
		m4 -I inc -D "$mode_def" "$@" inc/slice.m4 >"${override_dir}/simple-slices.conf"
	done
done
