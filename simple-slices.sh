#!/bin/sh

for path in /sys/class/block/*/queue/scheduler; do
	echo bfq >"$path"
done
