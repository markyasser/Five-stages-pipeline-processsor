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
    pc,
    intCounterValue,
    intSignalFromCounter,
    flagReg,
    dataFromMemory,
    MEMWB_ALU_result,
    MEMWB_Rdst_address,
    MEMWB_memRead,
    MEMWB_WB,
    clk
    // TODO: output new PC
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
input [1:0]intCounterValue;
input intSignalFromCounter;
input [31:0]pc;
input [15:0]flagReg;
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
wire [15:0] writeData;
wire [15:0] writeDataInCaseOfInt;

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
    (sel_readOrWrite == 1'b0) ? {16'b0,Rdst_value} : //memWrite
    (sel_readOrWrite == 1'b1) ? {16'b0,Rsrc_value} : 32'bz; //memRead 
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
// MUX to select memory write data in case of interupt
assign writeDataInCaseOfInt =
    (intCounterValue == 2'b00) ? Rsrc_value :
    (intCounterValue == 2'b01) ? pc[31:16] :
    (intCounterValue == 2'b10) ? pc[16:0] :
    (intCounterValue == 2'b11) ? flagReg : 16'bz;
// MUX to select memory write data in case we have interupt or normal operation
assign writeData =
    (intSignalFromCounter == 1'b0) ? Rsrc_value :
    (intSignalFromCounter == 1'b1) ? writeDataInCaseOfInt : 16'bz;

DataMemory mem(address, writeData, dataFromMemoryWire, memRead, memWrite, 1'b1, clk);
always@(*) begin    dataFromMemory = dataFromMemoryWire;end
always @(posedge clk) begin
    // Pass EXMEM buffer data to MEMWB buffer
    MEMWB_ALU_result = ALU_result;
    MEMWB_Rdst_address = Rdst_address;
    MEMWB_memRead = memRead;
    MEMWB_WB = WB;
    // Data memory
    // if isMemory = 1, set CS (chip select) of memory to 1, else CS = 0
    //CS = 1;
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