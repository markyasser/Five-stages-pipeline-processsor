module instruction_decode(
input clk,
input  [4:0] opCode,
input  [2:0] Rs,
input  [2:0] Rd,
input  [15:0] WB_data,
input  [2:0] WB_address,
input write_enable,
input rst,
input rstAll,

output [15:0] Rs_data,
output [15:0] Rd_data,
output [7:0] control_signals
);

control_unit CU(opCode,control_signals);
RegFile registers(write_enable,Rs,Rd,Rs_data,Rd_data,WB_data,clk,rst,rstAll,WB_address);


endmodule