module mux21(ImmValue, Src, LDM, Y);
output [15:0] Y;
input reg [15:0] ImmValue, Src;
input LDM;

assign Y=(LDM) ? ImmValue : Src;
endmodule
