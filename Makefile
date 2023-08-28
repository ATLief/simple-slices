#.SUFFIXES: .slice.m4 .slice

main: hier low.slice ml1.slice ml2.slice mh1.slice mh2.slice high.slice user.slice.d.conf system.slice.d.conf
	cp simple-slices.target usr/lib/systemd/system/

hier:
	mkdir -p usr/lib/systemd/system

%.slice: hier
	m4 $@.m4 > usr/lib/systemd/system/$*.slice

%.slice.d.conf: hier
	mkdir usr/lib/systemd/system/$*.slice.d
	m4 $@.m4 > usr/lib/systemd/system/$*.slice.d/simple-slices.conf

clean:
	rm -r usr
