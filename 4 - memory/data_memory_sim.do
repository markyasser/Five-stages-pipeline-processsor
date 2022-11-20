vlog data_memory.v
vsim DataMemory
add wave DataMemory/address DataMemory/data DataMemory/read DataMemory/write DataMemory/CS
force -freeze DataMemory/CS 1
force -freeze DataMemory/read 0
force -freeze DataMemory/write 1
force -freeze DataMemory/data 16'd25
force -freeze DataMemory/address 32'b0
run
force -freeze DataMemory/data 16'd30
force -freeze DataMemory/address 32'b1
run
noforce DataMemory/data
force -freeze DataMemory/read 1
force -freeze DataMemory/write 0
force -freeze DataMemory/address 32'b0
run
force -freeze DataMemory/address 32'b1
run


