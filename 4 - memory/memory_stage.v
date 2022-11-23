module MemoryStage (
    // ALU_zeroFlag,
    ALU_result,
    Rsrc_value,
    Rdst_value,
    Rdst_address,
    memWrite,
    memRead,
    WB,
    push,
    pop,
    sp,
    dataFromMemory,
    MEMWB_ALU_result,
    MEMWB_Rdst_address,
    MEMWB_memRead,
    MEMWB_WB,
    clk
);
// EXMEM input
input [15:0] ALU_result;
input [15:0] Rsrc_value;
input [15:0] Rdst_value;
input [2:0] Rdst_address;
// input ALU_zeroFlag;
input memRead;
input memWrite;
input WB;
input push;
input pop;
input clk;
// SP of processor
input [31:0]sp;
// MEMWB
// Read data
output reg [15:0] dataFromMemory;
output reg [15:0] MEMWB_ALU_result;
output reg [2:0] MEMWB_Rdst_address;
output reg MEMWB_memRead;
output reg MEMWB_WB;
reg CS;
wire isMemory;
wire [1:0] selPushOrPop;
wire sp_push;
wire sp_pop;
wire [1:0] selAddress;
wire [31:0] address;
wire pushOrPop;
wire [15:0] dataFromMemoryWire;
assign isMemory = memRead | memWrite;
// assign selPushOrPop = {push, pop};
// // Mux to make the signal 0 if push, 1 if pop, else z
// assign pushOrPop = 
//     (selPushOrPop == 2'b01) ? 1'b1 : //pop
//     (selPushOrPop == 2'b10) ? 1'b0 : //push 
//     1'bz;
// assign sp_push = sp + 1;
// assign sp_pop = sp;
// assign selAddress = {isMemory, pushOrPop};
// assign address =
//     (selAddress == 2'b00) ? Rdst_value : //memory but no push or pop
//     (selAddress == 2'b01) ? 16'bz : //Error: no push or pop without memory
//     (selAddress == 2'b10) ? sp_push : //memory + push 
//     (selAddress == 2'b11) ? sp_pop : //memory + pop 
//    16'bz;
assign selAddress = {memRead,memWrite};
assign address =                        //memory but no push or pop
    (selAddress == 2'b01) ? {16'b0,Rdst_value} : //Error: no push or pop without memory
    (selAddress == 2'b10) ? {16'b0,Rsrc_value} : 32'bz; //memory + push 
    //(selAddress == 2'b11) ? sp_pop : //memory + pop 
DataMemory mem(address, Rsrc_value, dataFromMemoryWire, memRead, memWrite, 1'b1, clk);
always @(posedge clk) begin
    // Pass EXMEM buffer data to MEMWB buffer
    MEMWB_ALU_result = ALU_result;
    MEMWB_Rdst_address = Rdst_address;
    MEMWB_memRead = memRead;
    MEMWB_WB = WB;
    // Data memory
    // if isMemory = 1, set CS (chip select) of memory to 1, else CS = 0
    //CS = 1;
    dataFromMemory = dataFromMemoryWire;
end
endmodule