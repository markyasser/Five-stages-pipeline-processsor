module reg_decode_exec(
    input clk,
    input [15:0]Imm_value,
    input [4:0]shmnt,
    input [15:0]Rs_data,
    input [15:0]Rd_data,
    input [2:0] Rd,
    input [7:0] control_signals,


    output reg [15:0]Imm_value_execute,
    output reg [4:0]shmnt_execute,
    output reg [15:0]Rs_data_execute,
    output reg [15:0]Rd_data_execute,
    output reg [2:0] Rd_execute,
    output reg [7:0] control_signals_execute
);
    reg [63:0] register;

    // always @(Rs_data,Rd_data) begin
    //     register[26:11] <= Rd_data;
    //     register[42:27] <= Rs_data;
    // end

    always @ (negedge clk,Rs_data,Rd_data) // read at the +ve edge
    begin
        register[7:0] <= control_signals;
        register[10:8] <= Rd;
        register[26:11] <= Rd_data;
        register[42:27] <= Rs_data;
        register[47:43] <= shmnt;
        register[63:48] <= Imm_value;
    end

    always @ (posedge clk) // write at the -ve edge
    begin
        control_signals_execute = register[7:0];
        Rd_execute = register[10:8];
        Rd_data_execute = register[26:11];
        Rs_data_execute = register[42:27];
        shmnt_execute = register[47:43];
        Imm_value_execute = register[63:48];
    end

endmodule