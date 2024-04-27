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

slices_stems := $(basename $(wildcard slice_meta/*.m4))
slices_list := $(addsuffix .slice, $(slices_stems))

m4_args := -I inc -U syscmd -U esyscmd -U mkstemp -U maketemp -D ss_slice_names="$(notdir $(slices_list))"

slices: $(slices_list)

manuals: $(addprefix $(BD)/,$(basename $(wildcard man/*.md)))

other_units: $(addsuffix .unit, $(basename $(wildcard other_units/*.m4)))

utilities: inc/sdm-header.sh $(wildcard utils/*) | $(BD)/bin
	cat $(<) utils/ssrun >$(BD)/bin/ssrun
	cat $(<) utils/sschange >$(BD)/bin/sschange
	cp utils/ssrun_sym utils/ssbrief $(BD)/bin/
	chmod -R a+x $(BD)/bin

other:
	mkdir -p $(BD)/modules $(BD)/udev $(BD)/profile
	cp modules.conf $(BD)/modules/simple-slices.conf
	cp udev.rules $(BD)/udev/86-simple-slices.rules
	m4 $(m4_args) -I /usr/share/doc/m4/examples profile.sh.m4 >$(BD)/profile/simple-slices.sh

$(BD)/bin $(BD)/snippets $(BD)/man:
	mkdir -p $(@)

%.unit %.slice.unit: %.m4
	@./m4_sdp.sh $(BD)/systemd $(basename $(@F)) -D ss_whitelist="neutral user" $(m4_args) $(^) $(m4_args_extra)

%.d.alias2override: inc/slice.m4 inc/assert-alias.m4
	@./m4_sdp.sh $(BD)/systemd $(basename $(@F)) $(m4_args) $(*D).m4 $(^)

%.slice.unit: override m4_args_extra := inc/template.slice.m4

%.slice: inc/service.m4 %.slice.unit $(addprefix %/,$(addsuffix .d.alias2override,$(sort $(foreach slice_stem,$(slices_stems),$(foreach preset,neutral user server desktop,$(shell m4 $(m4_args) $(slice_stem).m4 -D ss_extract=ss_alias_$(preset) inc/extract.m4)))))) | $(BD)/bin $(BD)/snippets
	ln -sf ./ssrun_sym "$(BD)/bin/$(*F)p"
	m4 $(m4_args) -D "ss_name=$(@F)" $(<) >"$(BD)/snippets/$(*F).conf"

$(BD)/man/%: man/%.md inc/man.md | $(BD)/man
	cat $(^) | pandoc --standalone --from=markdown --to=man --output="$(@)"

clean:
	rm -rf $(BD)

%:
