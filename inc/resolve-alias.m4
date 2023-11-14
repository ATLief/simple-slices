ifdef(`ss_is_user', `ifdef(`ss_user_alias', `define(`ss_alias_eff', ss_user_alias)')', `ifdef(`ss_system_alias', `define(`ss_alias_eff', ss_system_alias)')')dnl
