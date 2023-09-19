#.SUFFIXES: .slice.m4 .slice

main: hier low.slice ml1.slice ml2.slice mh1.slice mh2.slice high.slice user.slice.d.conf system.slice.d.conf
	cp simple-slices.target simple-slices.service build/systemd/
	cp ssexec_sym build/bin/
	cp modules.conf build/modules/simple-slices.conf
	cp simple-slices.sh build/lib/

hier:
	mkdir -p build/bin build/profile build/systemd build/snippets build/modules build/lib

%.slice: hier
	echo "alias ${*}p='${*}p '" >> build/profile/simple-slices.sh
	ln -s ./ssexec_sym "build/bin/${*}p"
	m4 -D ss_slice=$@ inc/service.m4 >"build/snippets/${*}.conf"
	m4 $@.m4 > build/systemd/$*.slice

%.slice.d.conf: hier
	mkdir build/systemd/$*.slice.d
	m4 $@.m4 > build/systemd/$*.slice.d/simple-slices.conf

clean:
	rm -rf build
