main: hier slices other_units manuals other

debug: clean main

slices_list := $(addsuffix .slice, $(basename $(notdir $(wildcard slice_meta/*.m4))))

m4_args := -I inc -D ss_slice_names="$(slices_list)"
m4_neutral := m4 $(m4_args) -D ss_preset=neutral
m4_user := m4 $(m4_args) -D ss_preset=user

slices: $(slices_list)

manuals_list := $(basename $(wildcard *.man.md))
manuals: $(manuals_list)

other_units_list := $(basename $(wildcard other_units/*.m4))
other_units: $(other_units_list)

other: hier
	cp ssrun ssrun_sym build/bin/
	cp modules.conf build/modules/simple-slices.conf
	cp udev.rules build/udev/simple-slices.rules
	$(m4_neutral) other_units/user@.service.d.m4 >build/systemd/neutral/user@.service.d/20-simple-slices.conf
	m4 $(m4_args) -I /usr/share/doc/m4/examples profile.sh.m4 >build/profile/simple-slices.sh

hier:
	mkdir -p build/bin build/profile build/systemd/user build/systemd/neutral build/snippets build/modules build/udev build/man
	mkdir -p build/systemd/neutral/user@.service.d

other_units/%.d:
	@echo "skipped automatic processing for $(@)"

other_units/%: hier
	$(m4_neutral) $(@).m4 > build/systemd/neutral/$(*)
	$(m4_user) $(@).m4 > build/systemd/user/$(*)

%.slice: hier
	@./alias2override.sh $(m4_args) "slice_meta/$(*).m4"
	ln -sf ./ssrun_sym "build/bin/$(*)p"
	m4 $(m4_args) -D ss_slice=$(@) inc/service.m4 >"build/snippets/$(*).conf"
	$(m4_neutral) -D ss_cmd_name="$(*)p" slice_meta/$(*).m4 inc/template.slice.m4 > build/systemd/neutral/$(@)
	$(m4_user) -D ss_cmd_name="$(*)p" slice_meta/$(*).m4 inc/template.slice.m4 > build/systemd/user/$(@)

%.man: hier
	cat $(@).md inc/man.md | pandoc --standalone --from=markdown --to=man --output="build/man/$(*)"

clean:
	rm -rf build

%:
