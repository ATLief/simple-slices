include(`slice2cmd.m4')dnl
[Unit]
Description=ss_desc
Documentation=man:simple-slices man:ssrun man:systemd.slice
changecom()dnl
#Documentation=man:slice2cmd(ss_name)
Before=simple-slices.target
