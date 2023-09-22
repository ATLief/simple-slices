[Unit]
Description=A small set of systemd slices with various priorities
Documentation=man:systemd.resource-control
Wants=low.slice ml1.slice ml2.slice mh1.slice mh2.slice high.slice
Before=slices.target

[Install]
WantedBy=ifdef(`ss_is_user', `basic.target', `slices.target')
