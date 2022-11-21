vlog instruction_memory.v
vsim InstructionMemory
add wave InstructionMemory/address InstructionMemory/writeData InstructionMemory/readData InstructionMemory/read InstructionMemory/write InstructionMemory/CS  InstructionMemory/clk
force -freeze InstructionMemory/clk 1 0, 0 {10 ps} -r 20
force -freeze InstructionMemory/CS 1
force -freeze InstructionMemory/read 0
force -freeze InstructionMemory/write 1
force -freeze InstructionMemory/writeData 16'd25
force -freeze InstructionMemory/address 32'b0
run
force -freeze InstructionMemory/writeData 16'd30
force -freeze InstructionMemory/address 32'b1
run
force -freeze InstructionMemory/read 1
force -freeze InstructionMemory/write 0
force -freeze InstructionMemory/address 32'b0
run
force -freeze InstructionMemory/address 32'b1
run


