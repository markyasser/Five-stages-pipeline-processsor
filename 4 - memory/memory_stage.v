// TODO: input (EXMEM)
// TODO: output (MEMWB)
module MemoryStage ();
// EXMEM
reg [15:0] ALU_result;
reg [15:0] Rsrc_value;
reg [15:0] Rdst_value;
reg [4:0] Rdst_address;
reg ALU_zeroFlag;
reg memRead;
reg memWrite;
reg WB;
reg push;
reg pop;
// MEMWB
reg [15:0] dataFromMemory;
// TODO: address mux
DataMemory mem(0, Rsrc_value, dataFromMemory, memRead, memWrite, 1);

endmodule