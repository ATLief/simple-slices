#!/bin/sh

prefix_num=20
for preset in neutral user server desktop; do
	for slice_alias in $(m4 "$@" -D "ss_preset=${preset}" inc/resolve-alias.m4 -D ss_extract=ss_alias_eff inc/extract.m4); do
		echo "$(basename "$0"): '$*' [${preset}] -> ${slice_alias} override"
		./m4_sdp.sh "$preset" "${slice_alias}.d" "$prefix_num" "$@" inc/slice.m4
	done
	prefix_num=`expr "$prefix_num" + 10`
done
