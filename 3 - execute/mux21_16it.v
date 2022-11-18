module mux21(input_0, input_1, S, Y);
output [15:0] Y;
input [15:0] input_0, input_1;
input S;

assign Y=(S) ? input_1 : input_0;
endmodule
