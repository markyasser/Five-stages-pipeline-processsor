module reg_exec_mem(
    input clk,
    input [15:0] ALU_result,
    input [15:0] Rs_data,
    input [15:0] Rd_data,
    input [2:0] Rd,
    input  memRead,
    input  memWrite,
    input  regWrite,
    input  [2:0]CCR_old,

    output reg [15:0] ALU_result_mem,
    output reg [15:0] Rs_data_mem,
    output reg [15:0] Rd_data_mem,
    output reg [2:0] Rd_mem,
    output reg  memRead_mem,
    output reg  memWrite_mem,
    output reg  regWrite_mem,
    output reg  [2:0] CCR_old_mem
);
    reg [56:0] register;

    always @ (negedge clk) // write at the -ve edge
    begin
        register[15:0] <= ALU_result;
        register[31:16] <= Rs_data;
        register[47:32] <= Rd_data;
        register[50:48] <= Rd;
        register[51] <=  memRead;
        register[52] <=  memWrite;
        register[53] <=  regWrite;
        register[56:54] <= CCR_old;
    end

    always @ (posedge clk) // read at the +ve edge
    begin
        ALU_result_mem = register[15:0];
        Rs_data_mem = register[31:16];
        Rd_data_mem = register[47:32];
        Rd_mem = register[50:48];
        memRead_mem = register[51];
        memWrite_mem = register[52];
        regWrite_mem = register[53];
        CCR_old_mem = register[56:54];
    end

endmodule