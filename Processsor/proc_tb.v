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


  initial
  begin
    clk = 1;
    reset = 1;
    interupt = 0;
    #1
     reset = 0;
    // In_Port = 16'h5;

    //test case : 1 operand
    // #99
    //  In_Port = 16'h19;
    // #49
    //  In_Port = 16'hF;
    // #49
    //  In_Port = 16'hFFFFF320;
    //test case: 2 operands
    #99
     In_Port = 16'h5;
    #49
     In_Port = 16'h19;
    #49
     In_Port = 16'hFFFF;
    #49
     In_Port = 16'hF320;

    // make interrupt in cycle 6
    // #30
    // interupt = 1;
    // #20
    // interupt = 0;


    // #(10*50)
    // // make interrupt in cycle 17
    // interupt = 1;
    // #50
    // interupt = 0;



    // #149
    // reset = 1;
    // #1
    // reset = 0;

  end

  always #25 clk =~ clk;
endmodule
