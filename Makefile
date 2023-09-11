#.SUFFIXES: .slice.m4 .slice

main: hier low.slice ml1.slice ml2.slice mh1.slice mh2.slice high.slice user.slice.d.conf system.slice.d.conf
	cp simple-slices.target build/systemd/

hier:
	mkdir -p build/systemd

%.slice: hier
	m4 $@.m4 > build/systemd/$*.slice

%.slice.d.conf: hier
	mkdir build/systemd/$*.slice.d
	m4 $@.m4 > build/systemd/$*.slice.d/simple-slices.conf

clean:
	rm -rf build
