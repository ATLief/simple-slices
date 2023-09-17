[Slice]
#CPUAccounting=yes
CPUWeight=ss_weight
#IOAccounting=yes
IOWeight=ss_weight
#MemoryAccounting=yes
ifdef(`ss_util_low', `MemoryLow=ss_util_low%')
MemoryHigh=ss_util_high%
MemoryMax=ss_util_max%
