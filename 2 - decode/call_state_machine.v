module CallStateMachine(clk,resetCPu,opcode,controlSignals,reg_FD_enable);
input clk;
// input reset;
input resetCPu;
input [4:0] opcode;
output reg_FD_enable;
output [33:0] controlSignals;

localparam ready = 3'b000;
localparam call = 3'b001;
localparam pushPc = 3'b010;
localparam pushCCR = 3'b011;
localparam jmpRdest = 3'b100;
localparam nop = 3'b101;

reg [2:0] state;
reg [2:0] nextState;

initial begin
    state = ready;
    nextState = ready;
end
// always @(*) begin
//     if (resetCPu) begin
//         state = ready;
//         nextState = ready;
//     end
// end

always @(posedge clk ) begin
    // if (reset) begin
    //     state <= ready;
    // end else begin
    //     state <= nextState;
    // end
    state <= nextState;
end

always @(state,opcode) begin
    case (state)
        ready:
            if (opcode==5'b01101) begin//in case of call
                nextState <= call;
            end else begin
                nextState <= ready;
            end
                
        call:
            nextState <= pushPc;
        pushPc:
            nextState <= pushCCR;
        pushCCR:
            nextState <= jmpRdest;
        jmpRdest:
            nextState <= nop;
        nop:
            nextState <= ready;
        
        default: 
            nextState <= ready;
    endcase
end

assign controlSignals= (state==call)? 34'b00_0100_0000_0000_0000_0000_0000_0000_0000:
    (state==pushPc)? 34'b00_1000_0000_0000_0000_0000_0000_0000_0000:
    (state==pushCCR)? 34'b00_0000_0000_0000_0000_0000_0000_1000_0001:
    (state==jmpRdest)? 34'b0:
    (state==nop)? 34'b00_0000_0000_0000_0000_0000_0000_0000_0000:
    34'b00_0000_0000_0000_0000_0000_0000_0000_0000;
    
assign reg_FD_enable = (state==ready)? 1'b1: 1'b0;
endmodule