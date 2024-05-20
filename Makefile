main: slices other_units utilities manuals other

BD := build

debug: clean main

deb:
	dpkg-buildpackage -T clean
	mkdir -p $(BD)/deb/src
	ln -sr * $(BD)/deb/src/
	rm $(BD)/deb/src/debian
	cp -a debian $(BD)/deb/src/
	cd $(BD)/deb/src && dpkg-buildpackage -b --no-sign --no-pre-clean

m4_args := -I inc -U syscmd -U esyscmd -U mkstemp -U maketemp
slices_src := $(shell for slice_src in slice_meta/*.m4; do echo $$(m4 $(m4_args) -D ss_extract=ss_weight $$slice_src inc/extract.m4):$$slice_src; done | sort -n | cut -d : -f 2)
slices_list := $(addsuffix .slice, $(basename $(slices_src)))
m4_args += -D ss_slice_names="$(notdir $(slices_list))"

slices: $(slices_list)

manuals: $(addprefix $(BD)/,$(basename $(wildcard man/*.md)))

other_units: $(addsuffix .unit, $(basename $(wildcard other_units/*.m4)))

utilities: inc/sdm-header.sh $(wildcard util/*) | $(BD)/util
	cat $(<) util/ssrun >$(BD)/util/ssrun
	cat $(<) util/sschange >$(BD)/util/sschange
	cp util/ssrun_sym util/ssbrief $(BD)/util/
	chmod -R a+x $(BD)/util

other:
	mkdir -p $(BD)/modules $(BD)/udev $(BD)/profile
	cp modules.conf $(BD)/modules/simple-slices.conf
	cp udev.rules $(BD)/udev/86-simple-slices.rules
	m4 $(m4_args) -I /usr/share/doc/m4/examples profile.sh.m4 >$(BD)/profile/simple-slices.sh

$(BD)/util $(BD)/snippets $(BD)/man:
	mkdir -p $(@)

%.unit %.slice.unit: %.m4
	@./m4_sdp.sh $(BD)/systemd $(basename $(@F)) -D ss_whitelist="neutral user" $(m4_args) $(^) $(m4_args_extra)

%.d.alias2override: inc/slice.m4 inc/assert-alias.m4
	@./m4_sdp.sh $(BD)/systemd $(basename $(@F)) $(m4_args) $(*D).m4 $(^)

%.slice.unit: override m4_args_extra := inc/template.slice.m4

%.slice: inc/service.m4 %.slice.unit $(addprefix %/,$(addsuffix .d.alias2override,$(sort $(foreach slice_src,$(slices_src),$(foreach preset,neutral user server desktop,$(shell m4 $(m4_args) $(slice_src) -D ss_extract=ss_alias_$(preset) inc/extract.m4)))))) | $(BD)/util $(BD)/snippets
	ln -sf ./ssrun_sym "$(BD)/util/$(*F)p"
	m4 $(m4_args) -D "ss_name=$(@F)" $(<) >"$(BD)/snippets/$(*F).conf"

$(BD)/man/%: man/%.md inc/man.md | $(BD)/man
	cat $(^) | pandoc --standalone --from=markdown --to=man --output="$(@)"

clean:
	rm -rf $(BD)

%:
