ifdef(`ss_is_user', `ifdef(`ss_alias_user', `define(`ss_alias_eff', ss_alias_user)')', `ifdef(`ss_alias_system', `define(`ss_alias_eff', ss_alias_system)')')dnl
