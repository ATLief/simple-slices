[Slice]
#CPUAccounting=yes
#IOAccounting=yes
#MemoryAccounting=yes
#TaskAccounting=yes

CPUWeight=ss_weight
IOWeight=ss_weight

ifdef(`ss_util_low', `MemoryLow=ss_util_low%')
MemoryHigh=ss_util_high%

MemoryMax=ss_util_max%
changecom()dnl
#TasksMax=ss_util_max%
