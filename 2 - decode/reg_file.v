module RegFile #(parameter N=16) (write_enable, read_addr_1,read_addr_2,read_data_1,read_data_2,write_data, clk,rst,rstAll,write_addr);
  input [N-1:0]write_data;
  output reg [N-1:0]read_data_1,read_data_2;
  input clk ,write_enable,rst,rstAll;
  input [2:0]read_addr_1,read_addr_2,write_addr;
  reg [N-1:0] regFile[0:7];
  //writing the data in any register must be before  reading it because
  //if you want to read and write data from the same register you will get the old value if you read it before writing it
  //so wrting must be in the first half cycle and reading in the second half cycle
  //if our clk starts with 1 write will be  at the positive edge and read at the negative edge
  integer i;
  always @ (negedge clk
             ) //read at the -ve edge
  begin
    read_data_1 = regFile[read_addr_1];
    read_data_2 = regFile[read_addr_2];
  end
  always @ (posedge clk) //write at the +ve edge
  begin
    if(rstAll)
    begin //write 0 in all registers
      for ( i= 0;i<8 ;i=i+1 )
      begin
        regFile[i]=0;
      end
    end
    else if(rst)
    begin//reset the register that we want to reset
      regFile[write_addr] = 0;
    end
    else if(write_enable)
    begin
      regFile[write_addr] = write_data;
    end
  end
endmodule
