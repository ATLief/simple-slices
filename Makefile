main: hier slices other_units manuals other

debug: clean main

deb:
	dpkg-buildpackage -T clean
	mkdir -p build/deb/src
	ln -sr * build/deb/src/
	rm build/deb/src/debian
	cp -a debian build/deb/src/
	cd build/deb/src && dpkg-buildpackage -b --unsigned-changes --no-pre-clean

slices_list := $(addsuffix .slice, $(basename $(wildcard slice_meta/*.m4)))

m4_args := -I inc -U syscmd -U esyscmd -U mkstemp -U maketemp -D ss_slice_names="$(notdir $(slices_list))"

slices: $(slices_list)

manuals: $(basename $(wildcard man/*.md))

other_units: $(addsuffix .unit, $(basename $(wildcard other_units/*.m4)))

other: hier
	cat inc/sdm-header.sh utils/ssrun >build/bin/ssrun
	cat inc/sdm-header.sh utils/sschange >build/bin/sschange
	cp utils/ssrun_sym utils/ssbrief build/bin/
	chmod -R a+x build/bin
	cp modules.conf build/modules/simple-slices.conf
	cp udev.rules build/udev/86-simple-slices.rules
	m4 $(m4_args) -I /usr/share/doc/m4/examples profile.sh.m4 >build/profile/simple-slices.sh

hier:
	mkdir -p build/bin build/profile build/snippets build/modules build/udev build/man
other_units/user@.service.d.unit:
	./m4_sdp.sh $(basename $(@F)) -D ss_whitelist="neutral" $(m4_args) $(basename $(@)).m4

%.unit %.slice.unit:
	@echo unit_name=$(basename $(@F)) src_file=$(*).m4
	./m4_sdp.sh $(basename $(@F)) -D ss_whitelist="neutral user" $(m4_args) $(*).m4 $(m4_args_extra)

%.slice.unit: override m4_args_extra := inc/template.slice.m4

%.slice: hier %.slice.unit
	@./alias2override.sh $(m4_args) $(*).m4
	ln -sf ./ssrun_sym "build/bin/$(*F)p"
	m4 $(m4_args) -D "ss_name=$(@F)" inc/service.m4 >"build/snippets/$(*F).conf"

man/%: hier
	cat $(@).md inc/man.md | pandoc --standalone --from=markdown --to=man --output="build/$(@)"

clean:
	rm -rf build

%:
