main: hier slices other_units manuals other

debug: clean main

default_preset := neutral
slices_list := $(addsuffix .slice, $(basename $(notdir $(wildcard slice_meta/*.m4))))
m4 := m4 -I inc -D ss_slice_names="$(slices_list)"
m4_dp := $(m4) -D "ss_preset=$(default_preset)"
m4_user := $(m4) -D ss_preset=user

slices: $(slices_list)

manuals_list := $(basename $(wildcard *.man.md))
manuals: $(manuals_list)

other_units_list := $(basename $(wildcard other_units/*.m4))
other_units: $(other_units_list)

other: hier
	cp ssrun ssrun_sym build/bin/
	cp modules.conf build/modules/simple-slices.conf
	cp udev.rules build/udev/simple-slices.rules
	$(m4_dp) other_units/user@.service.d.m4 >build/systemd/default/user@.service.d/20-simple-slices.conf
	$(m4) -I /usr/share/doc/m4/examples profile.sh.m4 >build/profile/simple-slices.sh

hier:
	mkdir -p build/bin build/profile build/systemd/user build/systemd/$(default_preset) build/snippets build/modules build/udev build/man
	ln -sf ./$(default_preset) build/systemd/default
	mkdir -p build/systemd/default/user@.service.d

other_units/%.d:
	@echo "skipped automatic processing for $(@)"

other_units/%: hier
	$(m4_dp) $(@).m4 > build/systemd/default/$(*)
	$(m4_user) $(@).m4 > build/systemd/user/$(*)

%.slice: hier
	@./alias2override.sh "slice_meta/$(*).m4"
	ln -sf ./ssrun_sym "build/bin/$(*)p"
	$(m4) -D ss_slice=$(@) inc/service.m4 >"build/snippets/$(*).conf"
	$(m4_dp) -D ss_cmd_name="$(*)p" slice_meta/$(*).m4 inc/template.slice.m4 > build/systemd/default/$(@)
	$(m4_user) -D ss_cmd_name="$(*)p" slice_meta/$(*).m4 inc/template.slice.m4 > build/systemd/user/$(@)

%.man: hier
	cat $(@).md inc/man.md | pandoc --standalone --from=markdown --to=man --output="build/man/$(*)"

clean:
	rm -rf build

%:
