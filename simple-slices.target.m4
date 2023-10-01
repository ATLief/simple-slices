[Unit]
Description=A small set of systemd slices with various priorities
Documentation=man:simple-slices man:systemd.resource-control
Wants=ss_slice_names
Before=slices.target

[Install]
WantedBy=ifdef(`ss_is_user', `basic.target', `slices.target')
