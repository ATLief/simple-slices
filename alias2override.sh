#!/bin/sh

for preset in neutral user server desktop; do
	for slice_alias in $(m4 "$@" -D "ss_preset=${preset}" inc/resolve-alias.m4 -D ss_extract=ss_alias_eff inc/extract.m4); do
		./m4_sdp.sh "${slice_alias}.d" "$@" inc/slice.m4 inc/assert-alias.m4
	done
done
