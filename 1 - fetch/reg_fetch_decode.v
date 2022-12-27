module reg_fetch_decode(
    input clk,
    input enable,
    input [31:0] Next_inst_addr,
    input [4:0] opcode,
    input [2:0] Rs,
    input [2:0] Rd,
    input [4:0] shmnt,
    input [31:0] pc,
    input int1,

    output reg [31:0] Next_inst_addr_decode,
    output reg [4:0] opcode_decode,
    output reg [2:0] Rs_decode,
    output reg [2:0] Rd_decode,
    output reg [4:0] shmnt_decode,
    output reg [31:0] pc_decode,
    output reg int1_decode
);
    reg [80:0] register;
    initial begin   // this solves the problem of the forwading unit not working on first 2 instruction as there is not values inside intermediate registers
        register = 0;
    end
    always @ (negedge clk) // write at the -ve edge
    begin
        if(enable == 1)begin
            register[31:0] <= Next_inst_addr;
            register[36:32] <= opcode;
            register[39:37] <= Rs;
            register[42:40] <= Rd;
            register[47:43] <= shmnt;
            register[79:48] <= pc;
            register[80] <= int1;
    end
    end

    always @ (posedge clk) // read at the +ve edge
    begin
        Next_inst_addr_decode = register[31:0];
        opcode_decode =  register[36:32];
        Rs_decode = register[39:37];
        Rd_decode = register[42:40];
        shmnt_decode = register[47:43];
        pc_decode = register[79:48];
        int1_decode = register[80];
    end

endmodule