main: hier slices slice_overrides targets manuals other

slices_list := $(basename $(wildcard *.slice.m4))
slices: $(slices_list)

slice_overrides_list := $(basename $(wildcard *.slice.d.conf.m4))
slice_overrides: $(slice_overrides_list)

manuals_list := $(basename $(wildcard *.man.md))
manuals: $(manuals_list)

targets_list := $(basename $(wildcard *.target.m4))
targets: $(targets_list)

EMPTY :=
SPACE := $(EMPTY) $(EMPTY)
COMMA := ,
slice_cmd_names_csv := $(subst $(SPACE),$(COMMA),$(addsuffix p, $(basename $(slices_list))))
other: hier
	cp ssrun ssrun_sym build/bin/
	cp modules.conf build/modules/simple-slices.conf
	cp udev.rules build/udev/simple-slices.rules
	m4 -I /usr/share/doc/m4/examples -D ss_cmd_names="$(slice_cmd_names_csv)" profile.sh.m4 > build/profile/simple-slices.sh

hier:
	mkdir -p build/bin build/profile build/systemd/user build/systemd/system build/snippets build/modules build/udev build/man

%.target: hier
	m4 -D ss_slice_names="$(slices_list)" $(@).m4 > build/systemd/system/$(@)
	m4 -D ss_slice_names="$(slices_list)" -D ss_is_user=true $(@).m4 > build/systemd/user/$(@)

%.slice: hier
	ln -sf ./ssrun_sym "build/bin/$(*)p"
	m4 -D ss_slice=$(@) inc/service.m4 >"build/snippets/$(*).conf"
	m4 -D ss_cmd_name="$(*)p" $(@).m4 > build/systemd/system/$(@)
	m4 -D ss_cmd_name="$(*)p" -D ss_is_user=true $(@).m4 > build/systemd/user/$(@)

%.user.slice.d.conf: hier
	mkdir -p build/systemd/user/$(*).slice.d
	m4 $(@).m4 > build/systemd/user/$(*).slice.d/simple-slices.conf

%.system.slice.d.conf: hier
	mkdir -p build/systemd/system/$(*).slice.d
	m4 $(@).m4 > build/systemd/system/$(*).slice.d/simple-slices.conf

%.man: hier
	pandoc --standalone --from=markdown --to=man $(@).md --output="build/man/$(*)"

clean:
	rm -rf build
