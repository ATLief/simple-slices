[Unit]
Description=A Manual CGroup with %i priority
Documentation=man:simple-slices man:systemd.resource-control

[Service]
ExitType=cgroup
Delegate=yes
Type=simple
ExecStart=sleep 30
Slice=%i.slice
