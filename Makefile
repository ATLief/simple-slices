main: hier slices targets manuals other

default_preset := neutral
slices_stems_all := $(basename $(notdir $(wildcard slice_meta/*.m4)))
slices_stems_native := $(filter-out %.hidden,$(slices_stems_all))
slices_list_native := $(addsuffix .slice, $(slices_stems_native))
slice_cmd_names := $(addsuffix p, $(slices_stems_native))
m4 := m4 -I inc -D ss_slice_names="$(slices_list_native)" -D ss_cmd_names="$(slice_cmd_names)" -D "ss_preset=$(default_preset)"
m4_user := $(m4) -D ss_preset=user

slices: $(addsuffix .slice, $(slices_stems_all))

manuals_list := $(basename $(wildcard *.man.md))
manuals: $(manuals_list)

targets_list := $(basename $(wildcard *.target.m4))
targets: $(targets_list)

other: hier
	cp ssrun ssrun_sym build/bin/
	cp modules.conf build/modules/simple-slices.conf
	cp udev.rules build/udev/simple-slices.rules
	cp user@.service.d build/systemd/default/user@.service.d/20-simple-slices.conf
	$(m4) -I /usr/share/doc/m4/examples profile.sh.m4 > build/profile/simple-slices.sh

hier:
	mkdir -p build/bin build/profile build/systemd/user build/systemd/$(default_preset) build/snippets build/modules build/udev build/man
	ln -sf ./$(default_preset) build/systemd/default
	mkdir -p build/systemd/default/user@.service.d

%.target: hier
	$(m4) $(@).m4 > build/systemd/default/$(@)
	$(m4_user) $(@).m4 > build/systemd/user/$(@)

%.hidden.slice: %.hidden.slice.d
	@echo "skipped most processing for $(@)"

%.slice: hier %.slice.d
	ln -sf ./ssrun_sym "build/bin/$(*)p"
	$(m4) -D ss_slice=$(@) inc/service.m4 >"build/snippets/$(*).conf"
	$(m4) -D ss_cmd_name="$(*)p" slice_meta/$(*).m4 inc/template.slice.m4 > build/systemd/default/$(@)
	$(m4_user) -D ss_cmd_name="$(*)p" slice_meta/$(*).m4 inc/template.slice.m4 > build/systemd/user/$(@)

%.slice.d: hier
	@./alias2override.sh "slice_meta/$(*).m4"

%.man: hier
	cat $(@).md inc/man.md | pandoc --standalone --from=markdown --to=man --output="build/man/$(*)"

clean:
	rm -rf build

%:
