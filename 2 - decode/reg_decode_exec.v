module reg_decode_exec(
    input clk,
    input [15:0]Imm_value,
    input [4:0]shmnt,
    input [15:0]Rs_data,
    input [15:0]Rd_data,
    input [2:0] Rd,
    input [34:0] control_signals,
    input [2:0] Rs,
    input int1,
    input int2,
    input [31:0] pcBeforeInterrupt,

    output reg [15:0]Imm_value_execute,
    output reg [4:0]shmnt_execute,
    output reg [15:0]Rs_data_execute,
    output reg [15:0]Rd_data_execute,
    output reg [2:0] Rd_execute,
    output reg [34:0] control_signals_execute,
    output reg [2:0] Rs_execute,
    output reg int1_execute,
    output reg int2_execute,
    output reg [31:0] pcBeforeInterrupt_execeute
);
    reg [127:0] register;
    initial begin   // this solves the problem of the forwading unit not working on first 2 instruction as there is not values inside intermediate registers
        register = 0;
    end
    // always @(Rs_data,Rd_data) begin
    //     register[26:11] <= Rd_data;
    //     register[42:27] <= Rs_data;
    // end

    always @ (negedge clk,Rs_data,Rd_data,Imm_value) // read at the +ve edge
    begin
        register[34:0] <= control_signals;
        register[37:35] <= Rd;
        register[53:38] <= Rd_data;
        register[69:54] <= Rs_data;
        register[74:70] <= shmnt;
        register[90:75] <= Imm_value;
        register[93:91] <= Rs;
        register[94] <= int1;
        register[95] <= int2;
        register[127:96] <= pcBeforeInterrupt;
    end

    always @ (posedge clk) // write at the -ve edge
    begin
        control_signals_execute = register[34:0] ;
        Rd_execute              = register[37:35];
        Rd_data_execute         = register[53:38];
        Rs_data_execute         = register[69:54];
        shmnt_execute           = register[74:70];
        Imm_value_execute       = register[90:75];
        Rs_execute              = register[93:91];
        int1_execute                    = register[94];
        int2_execute                    = register[95];
        pcBeforeInterrupt_execeute              = register[127:96];
    end

endmodule