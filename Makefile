main: hier slices targets manuals other

slices_stems_all := $(basename $(notdir $(wildcard slice_meta/*.m4)))
slices_stems_native := $(filter-out %.hidden,$(slices_stems_all))
slices_list_native := $(addsuffix .slice, $(slices_stems_native))
slices: $(addsuffix .slice, $(slices_stems_all))

manuals_list := $(basename $(wildcard *.man.md))
manuals: $(manuals_list)

targets_list := $(basename $(wildcard *.target.m4))
targets: $(targets_list)

EMPTY :=
SPACE := $(EMPTY) $(EMPTY)
COMMA := ,
slice_cmd_names_csv := $(subst $(SPACE),$(COMMA),$(addsuffix p, $(slices_stems_native)))
other: hier
	cp ssrun ssrun_sym build/bin/
	cp modules.conf build/modules/simple-slices.conf
	cp udev.rules build/udev/simple-slices.rules
	m4 -I /usr/share/doc/m4/examples -I inc -D ss_cmd_names="$(slice_cmd_names_csv)" profile.sh.m4 > build/profile/simple-slices.sh

hier:
	mkdir -p build/bin build/profile build/systemd/user build/systemd/system build/snippets build/modules build/udev build/man

%.target: hier
	m4 -I inc -D ss_slice_names="$(slices_list_native)" $(@).m4 > build/systemd/system/$(@)
	m4 -I inc -D ss_slice_names="$(slices_list_native)" -D ss_is_user=true $(@).m4 > build/systemd/user/$(@)

%.hidden.slice: %.hidden.slice.d
	@echo "skipped most processing for $(@)"

%.slice: hier %.slice.d
	ln -sf ./ssrun_sym "build/bin/$(*)p"
	m4 -I inc -D ss_slice=$(@) slice_meta/$(*).m4 inc/service.m4 >"build/snippets/$(*).conf"
	m4 -I inc -D ss_cmd_name="$(*)p" slice_meta/$(*).m4 inc/template.slice.m4 > build/systemd/system/$(@)
	m4 -I inc -D ss_cmd_name="$(*)p" -D ss_is_user=true slice_meta/$(*).m4 inc/template.slice.m4 > build/systemd/user/$(@)

%.slice.d: hier
	@./alias2override.sh "slice_meta/$(*).m4"

%.man: hier
	cat $(@).md inc/man.md | pandoc --standalone --from=markdown --to=man --output="build/man/$(*)"

clean:
	rm -rf build

%:
