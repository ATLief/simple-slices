include(`foreach2.m4')dnl
include(`slice2cmd.m4')dnl
foreach(`ss_cmd_name', (`translit(slice2cmd(ss_slice_names), ` ', `,')'), `alias ss_cmd_name="ss_cmd_name "
')dnl
