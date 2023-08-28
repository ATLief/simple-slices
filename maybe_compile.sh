#!/bin/bash

for f in *.m4; do
	m4 <"$f" >"../out/$(echo "$f" | rev | cut -c 4- | rev)"
done
