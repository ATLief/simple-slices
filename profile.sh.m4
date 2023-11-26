include(`foreach2.m4')dnl
foreach(`ss_cmd_name', (`translit(ss_cmd_names, ` ', `,')'), `alias ss_cmd_name="ss_cmd_name "
')dnl
