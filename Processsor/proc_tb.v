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

  parameter clock_period = 50;
  initial
  begin
    clk = 1;
    reset = 1;
    interupt = 0;
    In_Port = 16'h5;
    #1
     reset = 0;
    #49
    #(2*clock_period)
     In_Port = 16'h19;
    #(clock_period)
     In_Port = 16'hFFFFFFFF;
    #(2*clock_period)
     interupt = 1;
    #(3*clock_period)
     interupt = 0;
    In_Port = 16'hFFFFF320;
  end

  always #25 clk =~ clk;
endmodule

