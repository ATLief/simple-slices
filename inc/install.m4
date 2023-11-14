[Install]
#WantedBy=simple-slices.target
changecom()dnl
#ifdef(`ss_is_user', `ifdef(`ss_alias_user', Alias=ss_alias_user)', `ifdef(`ss_system_alias', Alias=ss_system_alias)')
