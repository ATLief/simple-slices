[Slice]
#CPUAccounting=yes
CPUWeight=ss_weight
#IOAccounting=yes
IOWeight=ss_weight
#MemoryAccounting=yes
ifdef(`ss_mem_low', `MemoryLow=ss_mem_low%')
MemoryHigh=ss_mem_high%
MemoryMax=ss_mem_max%
