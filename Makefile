main: hier simple-slices.target low.slice ml1.slice ml2.slice mh1.slice mh2.slice high.slice user.system.slice.d.conf system.system.slice.d.conf simple-slices.8.man.md ssrun.1.man.md
	cp ssrun ssrun_sym build/bin/
	cp modules.conf build/modules/simple-slices.conf
	cp udev.rules build/udev/simple-slices.rules

hier:
	mkdir -p build/bin build/profile build/systemd/user build/systemd/system build/snippets build/modules build/udev build/doc

%.target: hier
	m4 $@.m4 > build/systemd/system/$@
	m4 -D ss_is_user=true $@.m4 > build/systemd/user/$@

%.slice: hier
	echo "alias ${*}p='${*}p '" >> build/profile/simple-slices.sh
	ln -s ./ssrun_sym "build/bin/${*}p"
	m4 -D ss_slice=$@ inc/service.m4 >"build/snippets/${*}.conf"
	m4 -D ss_cmd_name="${*}p" $@.m4 > build/systemd/system/$@
	m4 -D ss_cmd_name="${*}p" -D ss_is_user=true $@.m4 > build/systemd/user/$@

%.user.slice.d.conf: hier
	mkdir -p build/systemd/user/$*.slice.d
	m4 $@.m4 > build/systemd/user/$*.slice.d/simple-slices.conf

%.system.slice.d.conf: hier
	mkdir build/systemd/system/$*.slice.d
	m4 $@.m4 > build/systemd/system/$*.slice.d/simple-slices.conf

%.man.md: hier
	pandoc --standalone --from=markdown --to=man $@ --output="build/doc/${*}"

clean:
	rm -rf build
