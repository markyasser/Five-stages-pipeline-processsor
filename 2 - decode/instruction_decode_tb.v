module instruction_decode_tb();
reg clk;
reg  [15:0] instruction;
reg  [15:0] WB_data;
reg  [2:0] WB_address;
reg write_enable;
reg rst;
reg rstAll;

wire [15:0] Rs_data;
wire [15:0] Rd_data;
wire [7:0] control_signals;

instruction_decode ID(clk,instruction,WB_data,WB_address,write_enable,rst,rstAll,Rs_data,Rd_data,control_signals);

always #25 clk = ~clk;
initial begin
    clk = 1;
    write_enable = 0;
    instruction = 16'b00011_001_010_00000;
    rstAll = 1;

    #50
    rstAll = 0;
    write_enable = 1;
    WB_address = 010;
    WB_data = 16'b0001_0001_0010_1111;


    #50
    write_enable = 0;
    WB_data = 16'b0001_0001_0010_1001;

    #50
    write_enable = 1;
    WB_address = 010;
    WB_data = 16'b0001_1001_0010_0110;
end

endmodule