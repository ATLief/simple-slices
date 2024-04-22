main: slices other_units utilities manuals other

debug: clean main

deb:
	dpkg-buildpackage -T clean
	mkdir -p build/deb/src
	ln -sr * build/deb/src/
	rm build/deb/src/debian
	cp -a debian build/deb/src/
	cd build/deb/src && dpkg-buildpackage -b --no-sign --no-pre-clean

slices_stems := $(basename $(wildcard slice_meta/*.m4))
slices_list := $(addsuffix .slice, $(slices_stems))

m4_args := -I inc -U syscmd -U esyscmd -U mkstemp -U maketemp -D ss_slice_names="$(notdir $(slices_list))"

slices: $(slices_list)

manuals: $(basename $(wildcard man/*.md))

other_units: $(addsuffix .unit, $(basename $(wildcard other_units/*.m4)))

utilities: | build/bin
	cat inc/sdm-header.sh utils/ssrun >build/bin/ssrun
	cat inc/sdm-header.sh utils/sschange >build/bin/sschange
	cp utils/ssrun_sym utils/ssbrief build/bin/
	chmod -R a+x build/bin

other:
	mkdir -p build/modules build/udev build/profile
	cp modules.conf build/modules/simple-slices.conf
	cp udev.rules build/udev/86-simple-slices.rules
	m4 $(m4_args) -I /usr/share/doc/m4/examples profile.sh.m4 >build/profile/simple-slices.sh

build/bin build/snippets build/man:
	mkdir -p $(@)

%.unit %.slice.unit:
	@./m4_sdp.sh $(basename $(@F)) -D ss_whitelist="neutral user" $(m4_args) $(*).m4 $(m4_args_extra)

%.d.alias2override:
	@./m4_sdp.sh $(basename $(@F)) $(m4_args) $(*D).m4 inc/slice.m4 inc/assert-alias.m4

%.slice.unit: override m4_args_extra := inc/template.slice.m4

%.slice: %.slice.unit $(addprefix %/,$(addsuffix .d.alias2override,$(sort $(foreach slice_stem,$(slices_stems),$(foreach preset,neutral user server desktop,$(shell m4 $(m4_args) $(slice_stem).m4 -D ss_extract=ss_alias_$(preset) inc/extract.m4)))))) | build/bin build/snippets
	ln -sf ./ssrun_sym "build/bin/$(*F)p"
	m4 $(m4_args) -D "ss_name=$(@F)" inc/service.m4 >"build/snippets/$(*F).conf"

man/%: | build/man
	cat $(@).md inc/man.md | pandoc --standalone --from=markdown --to=man --output="build/$(@)"

clean:
	rm -rf build

%:
