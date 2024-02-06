include(`foreach2.m4')dnl
foreach(`ss_cmd_name', (`translit(patsubst(ss_slice_names, `\.slice', `p'), ` ', `,')'), `alias ss_cmd_name="ss_cmd_name "
')dnl
