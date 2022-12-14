module cu_mux(
    input [4:0]opCode,
    input selector,
    output [4:0]out
);
assign out = selector == 0? opCode:5'b0;
endmodule