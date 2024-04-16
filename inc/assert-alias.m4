include(`resolve-alias.m4')dnl
ifdef(`ss_alias_eff', `ifdef(`ss_name', `ifelse(index(ss_alias_eff, ss_name), `-1', `m4exit(126)')', `m4exit(125)')', `m4exit(124)')dnl
