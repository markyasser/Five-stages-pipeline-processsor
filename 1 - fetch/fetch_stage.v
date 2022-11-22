module FetchStage (
    intRegAddress,
    jumpAddress,
    isImmediate,
    nextInstructionAddress,
    SHMNT,
    Rd,
    Rs,
    opCode,
    clk
);
// input
input [31:0] intRegAddress;
input [31:0] jumpAddress;
input clk;
// IF/ID
output reg [31:0] nextInstructionAddress;
output reg isImmediate;
output reg [3:0] SHMNT;
output reg [2:0] Rd;
output reg [2:0] Rs;
output reg [4:0] opCode;
// TODO: make a mux and set PC value from MUX
reg PC;
reg CS;
// Instruction memory
InstructionMemory mem(PC, Rsrc_value, dataFromMemoryWire, 1, 0, CS, clk);
always @(posedge clk) begin
    // Pass data to IF/ID buffer
    // TODO: get it from ALU
    nextInstructionAddress = 0;
    // CS always 1
    CS = 1;
    isImmediate = dataFromMemoryWire[0];
    SHMNT = dataFromMemoryWire[4:1];
    Rd = dataFromMemoryWire[7:5];
    Rs = dataFromMemoryWire[10:8];
    opCode = dataFromMemoryWire[14:10];
end
endmodule