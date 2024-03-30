main: hier slices other_units manuals other

debug: clean main

deb: clean
	mkdir -p build/deb/src
	ln -sr * build/deb/src/
	rm build/deb/src/debian
	cp -a debian build/deb/src/
	cd build/deb/src && dpkg-buildpackage -b --unsigned-changes

slices_list := $(addsuffix .slice, $(basename $(notdir $(wildcard slice_meta/*.m4))))

m4_args := -I inc -D ss_slice_names="$(slices_list)"

slices: $(slices_list)

manuals_list := $(basename $(wildcard man/*.md))
manuals: $(manuals_list)

other_units_list := $(basename $(wildcard other_units/*.m4))
other_units: $(other_units_list)

other: hier
	cat inc/sdm-header.sh utils/ssrun >build/bin/ssrun
	cat inc/sdm-header.sh utils/sschange >build/bin/sschange
	cp utils/ssrun_sym utils/ssbrief build/bin/
	chmod -R a+x build/bin
	cp modules.conf build/modules/simple-slices.conf
	cp udev.rules build/udev/86-simple-slices.rules
	./m4_sdp.sh neutral user@.service 20 $(m4_args) other_units/user@.service.d.m4
	m4 $(m4_args) -I /usr/share/doc/m4/examples profile.sh.m4 >build/profile/simple-slices.sh

hier:
	mkdir -p build/bin build/profile build/snippets build/modules build/udev build/man

other_units/%.d:
	@echo "skipped automatic processing for $(@)"

other_units/%:
	./m4_sdp.sh neutral $(*) 0 $(m4_args) $(@).m4
	./m4_sdp.sh user $(*) 0 $(m4_args) $(@).m4

%.slice: hier
	@./alias2override.sh $(m4_args) "slice_meta/$(*).m4"
	ln -sf ./ssrun_sym "build/bin/$(*)p"
	m4 $(m4_args) -D ss_slice=$(@) inc/service.m4 >"build/snippets/$(*).conf"
	./m4_sdp.sh neutral $(@) 0 $(m4_args) -D ss_cmd_name="$(*)p" slice_meta/$(*).m4 inc/template.slice.m4
	./m4_sdp.sh user $(@) 0 $(m4_args) -D ss_cmd_name="$(*)p" slice_meta/$(*).m4 inc/template.slice.m4

man/%: hier
	cat $(@).md inc/man.md | pandoc --standalone --from=markdown --to=man --output="build/$(@)"

clean:
	rm -rf build

%:
