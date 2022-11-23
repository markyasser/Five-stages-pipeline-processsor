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
    LDM_signal,
    Inst_as_Imm_value,
    clk
);
// input
input [31:0] intRegAddress;
input [31:0] jumpAddress;
input clk;
input LDM_signal;
// IF/ID
output reg [31:0] nextInstructionAddress;
output reg isImmediate;
output reg [4:0] SHMNT;
output reg [2:0] Rd;
output reg [2:0] Rs;
output reg [4:0] opCode;
output reg [15:0] Inst_as_Imm_value;
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

reg ldm;
// ----------------for testing--------------------
initial begin
    nextInstructionAddress = 32'b00100000;
    ldm = 0;
end
// -----------------------------------------------

// Instruction memory
InstructionMemory mem(PC, writeData, dataFromMemoryWire, 1'b1, 1'b0, CS, clk);
wire [15:0] mux_out;
assign mux_out = ldm == 1'b1 ? 16'b0 : dataFromMemoryWire;

assign Inst_as_Imm_value = dataFromMemoryWire;

always @(*)begin 
    if(LDM_signal == 1)
    begin 
        ldm = 1;
    end
    else
    begin 
        ldm = 0;
    end
    SHMNT = mux_out[4:0];
    Rd = mux_out[7:5];
    Rs = mux_out[10:8];
    opCode = mux_out[15:11];
end

always @(posedge clk) begin
    // Pass data to IF/ID buffer
    // TODO: get it from ALU
    
    PC = nextInstructionAddress;
    nextInstructionAddress <= PC + 32'h1;
    // CS always 1
    CS = 1;
    // isImmediate = dataFromMemoryWire[0];
    
end
endmodule