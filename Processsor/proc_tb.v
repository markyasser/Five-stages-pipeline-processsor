module ProcessorTb();
reg clk;
reg reset;
reg interupt;
reg [15:0]In_Port;
wire [15:0]Out_Port;

Processor cpu(
    clk,
    In_Port,
    reset,
    interupt,
    Out_Port
);


initial begin 
clk = 1;
reset = 1;
interupt = 0;
In_Port = 16'h5;
#1
reset = 0;
#149
In_Port = 16'h19;
#50
In_Port = 16'hFFFFFFFF;
#50
In_Port = 16'hFFFFF320;
// make interrupt in cycle 6    
interupt = 1;
#50
interupt = 0;


#(10*50)
// make interrupt in cycle 17
interupt = 1;
#50
interupt = 0;



// #149
// reset = 1;
// #1
// reset = 0;

end

always #25 clk =~ clk;
endmodule