module reg_decode_exec(
    input clk,
    input [15:0]Imm_value,
    input [4:0]shmnt,
    input [15:0]Rs_data,
    input [15:0]Rd_data,
    input [2:0] Rd,
    input [29:0] control_signals,
    input [2:0] Rs,
    


    output reg [15:0]Imm_value_execute,
    output reg [4:0]shmnt_execute,
    output reg [15:0]Rs_data_execute,
    output reg [15:0]Rd_data_execute,
    output reg [2:0] Rd_execute,
    output reg [29:0] control_signals_execute,
    output reg [2:0] Rs_execute
);
    reg [88:0] register;
    initial begin   // this solves the problem of the forwading unit not working on first 2 instruction as there is not values inside intermediate registers
        register = 0;
    end
    // always @(Rs_data,Rd_data) begin
    //     register[26:11] <= Rd_data;
    //     register[42:27] <= Rs_data;
    // end

    always @ (negedge clk,Rs_data,Rd_data,Imm_value) // read at the +ve edge
    begin
        register[29:0] <= control_signals;
        register[32:30] <= Rd;
        register[48:33] <= Rd_data;
        register[64:49] <= Rs_data;
        register[69:65] <= shmnt;
        register[85:70] <= Imm_value;
        register[88:86] <= Rs;
    end

    always @ (posedge clk) // write at the -ve edge
    begin
        control_signals_execute = register[29:0];
        Rd_execute = register[32:30];
        Rd_data_execute = register[48:33];
        Rs_data_execute = register[64:49];
        shmnt_execute = register[69:65];
        Imm_value_execute = register[85:70];
        Rs_execute = register[88:86];
    end

endmodule