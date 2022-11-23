// // a mux to set PC value 
// module mux21(Addition, jump, S, Y);
// output [31:0] Y;
// input [31:0] jump, Addition;
// input S;

// always @(Addition or jump)
//     begin
//         case(S)
//             0: // Addition
//             Y <= Addition;
//             1: // jump
//             Y <= jump ;
//         endcase
//     end

// // assign Y=(S) ? jump : Addition;
// endmodule

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
output reg [4:0] SHMNT;
output reg [2:0] Rd;
output reg [2:0] Rs;
output reg [4:0] opCode;
// TODO: make a mux and set PC value from MUX
// TODO: make ALU to inrement PC by 1 ---> OR 2 ?
reg [31:0] PC;
reg [15:0] writeData;
// always @(PC)
//     begin
//     	nextInstructionAddress <= PC + 32'h00000001;
//     end

reg CS;
wire [15:0] dataFromMemoryWire;


// ----------------for testing--------------------
initial begin
    nextInstructionAddress = 32'b00100000;
end
// -----------------------------------------------

// Instruction memory
InstructionMemory mem(PC, writeData, dataFromMemoryWire, 1'b1, 1'b0, CS, clk);
always @(posedge clk) begin
    // Pass data to IF/ID buffer
    // TODO: get it from ALU
    
    PC = nextInstructionAddress;
    nextInstructionAddress <= PC + 32'h1;
    // CS always 1
    CS = 1;
    // isImmediate = dataFromMemoryWire[0];
    SHMNT = dataFromMemoryWire[4:0];
    Rd = dataFromMemoryWire[7:5];
    Rs = dataFromMemoryWire[10:8];
    opCode = dataFromMemoryWire[15:11];
end
endmodule