vlog instruction_memory.v
vsim InstructionMemory
add wave InstructionMemory/address InstructionMemory/data InstructionMemory/read InstructionMemory/write InstructionMemory/CS
force -freeze InstructionMemory/CS 1
force -freeze InstructionMemory/read 0
force -freeze InstructionMemory/write 1
force -freeze InstructionMemory/data 16'd25
force -freeze InstructionMemory/address 32'b0
run
force -freeze InstructionMemory/data 16'd30
force -freeze InstructionMemory/address 32'b1
run
noforce InstructionMemory/data
force -freeze InstructionMemory/read 1
force -freeze InstructionMemory/write 0
force -freeze InstructionMemory/address 32'b0
run
force -freeze InstructionMemory/address 32'b1
run


