module intCounter(intSignal,clk,reset,count,fireInt);
  input clk;
  input reset;
  input intSignal;
  output reg [2:0] count;
  output reg fireInt;
  always @(*) begin
    if (intSignal) begin
        fireInt = 1;
    end
  end
  //always block will be executed at each and every positive edge of the clock
  always@(posedge clk) 
  begin
    // You need to reset before using the counter for the first time
    if(reset) begin
        count = 3'b0;
    end 
    else if(fireInt) begin
        if (count == 3'd4) begin
            fireInt = 0;
            count = 3'b0;
        end
        else begin
            count = count + 1;
            fireInt = 1;
        end
    end
  end
endmodule