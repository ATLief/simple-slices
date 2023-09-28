[Install]
#WantedBy=simple-slices.target
changecom()dnl
#ifdef(`ss_is_user', ifdef(`ss_user_alias', `Alias=ss_user_alias'), ifdef(`ss_system_alias', `Alias=ss_system_alias'))
