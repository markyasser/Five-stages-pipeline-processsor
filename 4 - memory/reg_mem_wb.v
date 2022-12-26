module reg_mem_WB(
    input clk,
    input [15:0] dataFromMemory,
    input [15:0] MEMWB_ALU_result,
    input [2:0] MEMWB_Rdst_address,
    input MEMWB_memRead,
    input MEMWB,
    input [1:0] shmnt,
    input Pop,


    output reg [15:0] dataFromMemory_WB,
    output reg [15:0] MEMWB_ALU_result_wB,
    output reg [2:0] MEMWB_Rdst_address_WB,
    output reg MEMWB_memRead_WB,
    output reg MEMWB_WB,
    output reg  [1:0] shmnt_WB,
    output reg Pop_WB
);
    reg [39:0] register;
    initial begin   // this solves the problem of the forwading unit not working on first 2 instruction as there is not values inside intermediate registers
        register = 0;
    end
    always @ (negedge clk) 
    begin
        register[15:0] <= dataFromMemory;
        register[31:16] <= MEMWB_ALU_result;
        register[34:32] <= MEMWB_Rdst_address;
        register[35] <= MEMWB_memRead;
        register[36] <= MEMWB;
        register[37] <= Pop;
        register[39:38] <= shmnt;
    end

    always @ (posedge clk) 
    begin
        dataFromMemory_WB = register[15:0];
        MEMWB_ALU_result_wB = register[31:16];
        MEMWB_Rdst_address_WB = register[34:32];
        MEMWB_memRead_WB = register[35];
        MEMWB_WB = register[36];
        Pop_WB = register[37];
        shmnt_WB = register[39:38];
    end

endmodule