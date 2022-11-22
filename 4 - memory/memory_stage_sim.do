vlog memory_stage.v
vsim MemoryStage
add wave MemoryStage/clk MemoryStage/ALU_zeroFlag MemoryStage/ALU_result MemoryStage/Rsrc_value MemoryStage/Rdst_value MemoryStage/Rdst_address MemoryStage/memWrite MemoryStage/memRead MemoryStage/WB MemoryStage/push MemoryStage/pop MemoryStage/sp MemoryStage/dataFromMemory MemoryStage/MEMWB_ALU_result MemoryStage/MEMWB_Rdst_address MemoryStage/MEMWB_memRead MemoryStage/MEMWB_WB
force -freeze MemoryStage/clk 1 0, 0 {10 ps} -r 20

force -freeze MemoryStage/ALU_zeroFlag 0
force -freeze MemoryStage/ALU_result 16'd25
force -freeze MemoryStage/Rsrc_value 16'd30
force -freeze MemoryStage/memWrite 1
force -freeze MemoryStage/memRead 0
force -freeze MemoryStage/WB 0
force -freeze MemoryStage/push 0
force -freeze MemoryStage/pop 0
force -freeze MemoryStage/push 1
force -freeze MemoryStage/Rdst_value 32'd100
run
force -freeze MemoryStage/Rsrc_value 16'd40
force -freeze MemoryStage/Rdst_value 32'b101
run
force -freeze MemoryStage/memWrite 0
force -freeze MemoryStage/memRead 1
force -freeze MemoryStage/Rdst_value 32'b100
run
force -freeze MemoryStage/Rdst_value 32'b101
run



