module ProcessorTb();
reg clk;
reg reset;
reg [15:0]In_Port;
wire [15:0]Out_Port;

Processor cpu(
    clk,
    In_Port,
    reset,
    Out_Port
);


initial begin 
clk = 1;
reset = 1;
In_Port = 32'b1010;
#1
reset = 0;


#149
reset = 1;
#1
reset = 0;
end

always #25 clk =~ clk;
endmodule