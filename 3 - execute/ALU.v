// ALU module
module ALU(Src,ImmValue,LDM_signal,Dst,ALU_ADD,ALU_NOT,ALU_Result,CCR,clk);
    input [15:0] Src,Dst,ImmValue;  // ALU 16-bit Inputs                 
    input ALU_ADD,ALU_NOT,LDM_signal; // ALU Selection
    input clk;
    output reg [15:0] ALU_Result; // ALU 16-bit Output
    output reg[2:0] CCR; // flags register
    //wires
    wire ZeroFlag,NegativeFlag,OverflowFlag;
    wire [2:0] control_Bits;
    //The Operations
    assign control_Bits[0] = ALU_ADD;
    assign control_Bits[1] = ALU_NOT;
    assign control_Bits[2] = LDM_signal;
    // Temp Reg And wire
    wire[15:0] Source;
    wire [15:0] tmp;
    assign tmp = {1'b0,Source} + {1'b0,Dst};

    assign Source = LDM_signal == 1 ? ImmValue : Src;

    assign ALU_Result = 
    (control_Bits == 3'b001)? Source + Dst: // Addition    
    (control_Bits == 3'b010)? ~(Dst) : // NOT    
    (control_Bits == 3'b100)? Source : 16'bx; // LDM
    

    //ALU Result
    // always @(posedge clk)
    // begin
    //     case(control_Bits)
    //     2'b01: // Addition
    //     ALU_Result <= Src + Dst ;
    //     2'b10: // NOT
    //     ALU_Result <= ~(Src) ;
    //     default:
    //     ALU_Result <= Dst ;
    //     endcase
       
    // end
    // always @(negedge clk)
    // begin
    //      // Flag Register
    //     CCR[0] = (ALU_Result == 0) ? 1 : 0;
    //     CCR[1] = (ALU_Result[15] == 1) ? 1 : 0;
    //     CCR[2] = (control_Bits == 1 && Src[15]==Dst[15] && Src[15] != tmp[15]) ? 1 : 0;
    // end
    // // Assigning Flags
    assign ZeroFlag = (ALU_Result == 0) ? 1 : 0;
    assign NegativeFlag = (ALU_Result[15] == 1) ? 1 : 0;
    assign OverflowFlag = (control_Bits == 1 && Source[15]==Dst[15] && Source[15] != tmp[15]) ? 1 : 0;
    // // Flag Register
    assign CCR[0] = ZeroFlag;
    assign CCR[1] = NegativeFlag;
    assign CCR[2] = OverflowFlag;

endmodule
