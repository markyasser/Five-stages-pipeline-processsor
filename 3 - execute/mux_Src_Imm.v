module mux21(Source, ImmValue, LDM_signal, Src);
output [15:0] Src;
input [15:0] Source, ImmValue;
input LDM_signal;

assign Src=(LDM_signal == 1) ? ImmValue : Source;
endmodule
