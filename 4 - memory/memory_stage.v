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
reg newSP;
reg CS;
wire [15:0] dataFromMemoryWire;
// wire isMemory;
wire sp_push;
wire sp_pop;
wire [31:0] address;

wire sel_stackOrMem;
wire sel_pushOrPop;
wire sel_readOrWrite;
wire [31:0] address_pushOrPop;
wire [31:0] address_readOrWrite;
// assign isMemory = memRead | memWrite;

assign sp_push = sp;
assign sp_pop = sp + 1;
// MUX to select memory address in case we have memRead or memWrite
assign sel_readOrWrite = memRead;
assign address_readOrWrite =
    (sel_readOrWrite == 1'b0) ? {16'b0,Rsrc_value} : //memWrite
    (sel_readOrWrite == 1'b1) ? {16'b0,Rdst_value} : 32'bz; //memRead 
// MUX to select memory address in case we have push or pop
assign sel_pushOrPop = pop;
assign address_pushOrPop =
    (sel_pushOrPop == 1'b0) ? sp_push : //push
    (sel_pushOrPop == 1'b1) ? sp_pop : 32'bz; //pop 
// MUX to select memory address in case we have push/pop or memRead/memWrite
assign sel_stackOrMem = !push & !pop;
assign address =
    (sel_stackOrMem == 1'b0) ? address_pushOrPop :
    (sel_stackOrMem == 1'b1) ? address_readOrWrite : 32'bz;
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
    // update sp in case of push or pop
    if (sel_stackOrMem == 0) begin
        if (push) begin
            newSP = sp - 1;
        end
        else begin
            newSP = sp_pop;
        end
    end
    else begin
        newSP = sp;
    end
end
endmodule