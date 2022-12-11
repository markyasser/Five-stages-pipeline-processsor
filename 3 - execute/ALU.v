// ALU module
module ALU(Src,Dst,ALU_ADD,ALU_NOT,ALU_INC,ALU_DEC,ALU_SUB,ALU_AND,ALU_OR,ALU_SHL,ALU_SHR,ALU_IN,ALU_OUT,ALU_LDM,ALU_Result,CCR,IN_port,OUT_port);
    input [15:0] Src,Dst,IN_port,OUT_port;  // ALU 16-bit Inputs                 
    input ALU_ADD,ALU_NOT,ALU_INC,ALU_DEC,ALU_SUB,ALU_AND,ALU_OR,ALU_IN,ALU_OUT,ALU_SHL,ALU_SHR,ALU_LDM; // ALU Selection
    // input clk;
    output reg [15:0] ALU_Result; // ALU 16-bit Output
    output reg[2:0] CCR; // flags register
    //wires
    wire ZeroFlag,NegativeFlag,CarryFlag;
    // output [8:0] control_Bits;

    //The Operations
    // assign control_Bits[0] = ALU_ADD;
    // assign control_Bits[1] = ALU_NOT;
    // assign control_Bits[2] = ALU_IN;
    // assign control_Bits[3] = ALU_INC;
    // assign control_Bits[4] = ALU_DEC;
    // assign control_Bits[5] = ALU_SUB;
    // assign control_Bits[6] = ALU_AND;
    // assign control_Bits[7] = ALU_OR;
    // assign control_Bits[8] = ALU_LDM;
    // assign control_Bits[8] = ALU_IN;


    // Temp Reg And wire
    // wire[15:0] Source;
    wire [16:0] tmp;

    // assign Source = (LDM_signal == 1) ? ImmValue : Src;
    assign tmp = {1'b0,Src} + {1'b0,Dst};

    // ALU Result
    assign ALU_Result = 
    (ALU_ADD == 1'b1)? Src + Dst: // Addition    
    (ALU_NOT == 1'b1)? ~(Dst) : // NOT    
    (ALU_OUT == 1'b1)? Src :    // OUT
    (ALU_INC == 1'b1) ? Dst + 1:
    (ALU_DEC == 1'b1) ? Dst - 1:
    (ALU_SUB == 1'b1) ? Dst - Src:
    (ALU_AND == 1'b1) ? Src & Dst:
    (ALU_OR == 1'b1) ?  Src | Dst:
    (ALU_SHL == 1'b1) ?  Dst <<< Src:
    (ALU_SHR == 1'b1) ?  Dst >>> Src:
    (ALU_IN == 1'b1) ? IN_port:
    (ALU_LDM == 1'b1) ? Src: 16'hx;


    // // Assigning Flags
    // assign ZeroFlag = 
    // (control_Bits == 0) ? CCR_old[0]:
    // (ALU_Result == 0) ? 1 : 0;
    // assign NegativeFlag =
    // (control_Bits == 0) ? CCR_old[1]:
    // (ALU_Result[15] == 1) ? 1 : 0;
    // assign CarryFlag =
    // (control_Bits == 0) ? CCR_old[2]:
    // (control_Bits == 1 && tmp[16] == 1) ? 1 : 0;

    // Assigning Flags
    assign ZeroFlag = (ALU_Result == 0) ? 1 : 0;
    assign NegativeFlag = (ALU_Result[15] == 1) ? 1 : 0;
    assign CarryFlag = (ALU_ADD == 1 && tmp[16] == 1) ? 1 : 0;


    // Flag Register
    assign CCR[0] = ZeroFlag;
    assign CCR[1] = NegativeFlag;
    assign CCR[2] = CarryFlag;

endmodule
