// ALU module
module ALU(Src,Dst,ALU_ADD,ALU_NOT,ALU_Result,CCR,clk);
    input [15:0] Src,Dst;  // ALU 16-bit Inputs                 
    input ALU_ADD,ALU_NOT;// ALU Selection
    input clk;
    output reg [15:0] ALU_Result; // ALU 16-bit Output
    output reg[2:0] CCR; // flags register
    //wires
    wire ZeroFlag,NegativeFlag,OverflowFlag;
    wire [1:0] control_Bits;
    //The Operations
    assign control_Bits[0] = ALU_ADD;
    assign control_Bits[1] = ALU_NOT;
    // Temp Reg And wire
    wire [15:0] tmp;
    assign tmp = {1'b0,Src} + {1'b0,Dst};


    
    assign ALU_Result = 
    (control_Bits == 2'b01)? Src + Dst: // Addition    
    (control_Bits == 2'b10)? ~(Src): 16'bx; // NOT    
    

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
    assign OverflowFlag = (control_Bits == 1 && Src[15]==Dst[15] && Src[15] != tmp[15]) ? 1 : 0;
    // // Flag Register
    assign CCR[0] = ZeroFlag;
    assign CCR[1] = NegativeFlag;
    assign CCR[2] = OverflowFlag;

endmodule
