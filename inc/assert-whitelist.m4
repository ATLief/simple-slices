ifdef(`ss_whitelist', `ifdef(`ss_preset', `ifelse(index(ss_whitelist, ss_preset), `-1', `m4exit(127)')', `m4exit(128)')')dnl
