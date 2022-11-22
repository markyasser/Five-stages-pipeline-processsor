module instruction_decode(
input clk,
input  [15:0] instruction,
input  [15:0] WB_data,
input  [2:0] WB_address,
input write_enable,
input rst,
input rstAll,

output [15:0] Rs_data,
output [15:0] Rd_data,
output [7:0] control_signals
);

control_unit CU(instruction[15:11],control_signals);
RegFile registers(write_enable,instruction[10:8],instruction[7:5],Rs_data,Rd_data,WB_data,clk,rst,rstAll,WB_address);

endmodule