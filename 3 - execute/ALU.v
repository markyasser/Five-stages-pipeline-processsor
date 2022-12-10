// ALU module
module ALU(Src,Dst,ALU_ADD,ALU_NOT,ALU_INC,ALU_DEC,ALU_SUB,ALU_AND,ALU_OR,ALU_IN,ALU_OUT,ALU_Result,CCR,CCR_old,IN_port,OUT_port);
    input [15:0] Src,Dst,IN_port,OUT_port;  // ALU 16-bit Inputs                 
    input ALU_ADD,ALU_NOT,ALU_INC,ALU_DEC,ALU_SUB,ALU_AND,ALU_OR,ALU_IN,ALU_OUT; // ALU Selection
    input [2:0] CCR_old;
    // input clk;
    output reg [15:0] ALU_Result; // ALU 16-bit Output
    output reg[2:0] CCR; // flags register
    //wires
    wire ZeroFlag,NegativeFlag,CarryFlag;
    wire [7:0] control_Bits;


    //The Operations
    assign control_Bits[0] = ALU_ADD;
    assign control_Bits[1] = ALU_NOT;
    assign control_Bits[2] = ALU_IN;
    assign control_Bits[3] = ALU_INC;
    assign control_Bits[4] = ALU_DEC;
    assign control_Bits[5] = ALU_SUB;
    assign control_Bits[6] = ALU_AND;
    assign control_Bits[7] = ALU_OR;
    // assign control_Bits[8] = ALU_IN;


    // Temp Reg And wire
    // wire[15:0] Source;
    wire [16:0] tmp;

    // assign Source = (LDM_signal == 1) ? ImmValue : Src;
    assign tmp = {1'b0,Src} + {1'b0,Dst};

    // ALU Result
    assign ALU_Result = 
    (control_Bits == 3'b001)? Src + Dst: // Addition    
    (control_Bits == 3'b010)? ~(Dst) : // NOT    
    (control_Bits == 3'b100)? Src : // LDM
    (ALU_INC == 1'b1) ? Dst + 1:
    (ALU_DEC == 1'b1) ? Dst - 1:
    (ALU_SUB == 1'b1) ? Dst - Src:
    (ALU_AND == 1'b1) ? Src & Dst:
    (ALU_OR == 1'b1) ?  Src | Dst:
    (ALU_IN == 1'b1) ? IN_port: 16'h00;


    // // Assigning Flags
    assign ZeroFlag = 
    (control_Bits == 0) ? CCR_old[0]:
    (ALU_Result == 0) ? 1 : 0;
    assign NegativeFlag =
    (control_Bits == 0) ? CCR_old[1]:
    (ALU_Result[15] == 1) ? 1 : 0;
    assign CarryFlag =
    (control_Bits == 0) ? CCR_old[2]:
    (control_Bits == 1 && tmp[16] == 1) ? 1 : 0;

    // Flag Register
    assign CCR[0] = ZeroFlag;
    assign CCR[1] = NegativeFlag;
    assign CCR[2] = CarryFlag;

endmodule
