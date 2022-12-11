`include "../1 - fetch/fetch_stage.v"
`include "../1 - fetch/instruction_memory.v"
`include "../1 - fetch/reg_fetch_decode.v"

`include "../2 - decode/instruction_decode.v"
`include "../2 - decode/reg_decode_exec.v"
`include "../2 - decode/reg_file.v"
`include "../2 - decode/control_unit.v"

`include "../3 - execute/ALU.v"
`include "../3 - execute/mux_Src_Imm.v"
`include "../3 - execute/reg_exec_mem.v"

`include "../4 - memory/memory_stage.v"
`include "../4 - memory/data_memory.v"
`include "../4 - memory/reg_mem_wb.v"

`include "../5 - write back/write_back.v"

module Processor (
    input clk
);
    reg [2:0] CCR; // flag register
    reg [15:0] In_Port;
    reg [15:0] Out_Port;

    // fetch stage
    reg [31:0] jumpAddress;
    wire [31:0] nextInstructionAddress;
    wire isImmediate;
    wire [4:0] SHMNT;
    wire [2:0] Rd;
    wire [2:0] Rs;
    wire [4:0] opCode;
    wire [29:0] control_signals; // will be initialized in decode stage
    wire [15:0] Inst_as_Imm_value;
    FetchStage Fetch(32'b0,32'b0,isImmediate,nextInstructionAddress,SHMNT,Rd,Rs,opCode,control_signals[13],Inst_as_Imm_value,clk);
    
    // register between fetch and decode
    wire [31:0] Next_inst_addr_decode;
    wire [4:0]  opcode_decode;
    wire [2:0]  Rs_decode;
    wire [2:0]  Rd_decode;
    wire [4:0]  shmnt_decode;
    reg_fetch_decode reg_fetch_decode(clk,nextInstructionAddress,opCode,Rs,Rd,SHMNT,
    Next_inst_addr_decode,opcode_decode,Rs_decode,Rd_decode,shmnt_decode);

    // decode stage
    wire [15:0] WB_data;    // will be initiallized from write back (down)
    wire [2:0] WB_address;  // will be initiallized from write back (down)
    wire regWrite_WB;       // will be initiallized from write back (down)
    reg rst;
    reg rstAll;
    wire [15:0] Rs_data;
    wire [15:0] Rd_data;
    
    control_unit CU(opcode_decode,control_signals);
    RegFile registers(regWrite_WB,Rs_decode,Rd_decode,Rs_data,Rd_data,WB_data,clk,rst,rstAll,WB_address); 
    
    // register between decode and execute
    wire [15:0]Imm_value_execute;
    wire [4:0]shmnt_execute;
    wire [15:0]Rs_data_execute;
    wire [15:0]Rd_data_execute;
    wire [2:0] Rd_execute;
    wire [29:0] control_signals_execute;
    reg_decode_exec reg_dec_exec(clk,Inst_as_Imm_value,shmnt_decode,Rs_data,Rd_data,Rd_decode,control_signals,
    Imm_value_execute,shmnt_execute,Rs_data_execute,Rd_data_execute,Rd_execute,control_signals_execute);

    // execute stage
    wire [15:0] ALU_Result; // ALU 16-bit Output
    wire [2:0] ccr_out; // flags register
    wire [8:0] is_alu;  // check if there is an ALU operation
    wire [15:0] src; // ALU source
    mux21 mux2x1(Rs_data_execute,Imm_value_execute,control_signals_execute[13],src);
    ALU alu(src,Rd_data_execute,
    control_signals_execute[21],
    control_signals_execute[27],
    control_signals_execute[26],
    control_signals_execute[25],
    control_signals_execute[20],
    control_signals_execute[19],
    control_signals_execute[18],
    control_signals_execute[17],
    control_signals_execute[16],
    control_signals_execute[23],
    control_signals_execute[24],
    control_signals_execute[13],
    ALU_Result,ccr_out,In_Port,Out_Port);

    always @(ccr_out) begin if(
    control_signals_execute[21] == 1 ||
    control_signals_execute[27] == 1 ||
    control_signals_execute[26] == 1 ||
    control_signals_execute[25] == 1 ||
    control_signals_execute[20] == 1 ||
    control_signals_execute[19] == 1 ||
    control_signals_execute[18] == 1 ||
    control_signals_execute[17] == 1 ||
    control_signals_execute[16] == 1 ||
    control_signals_execute[23] == 1 ||
    control_signals_execute[24] == 1 ||
    control_signals_execute[13] == 1 )begin CCR = ccr_out; end end

    // register between execute and memory
    wire [15:0] ALU_result_mem;
    wire [15:0] Rs_data_mem;
    wire [15:0] Rd_data_mem;
    wire [2:0] Rd_mem;
    wire  memRead_mem;
    wire  memWrite_mem;
    wire  regWrite_mem;
    reg_exec_mem reg_exec_mem(clk,ALU_Result,Rs_data_execute,Rd_data_execute,Rd_execute,control_signals_execute[2],control_signals_execute[1],control_signals_execute[3],
    ALU_result_mem,Rs_data_mem,Rd_data_mem,Rd_mem,memRead_mem,memWrite_mem,regWrite_mem);

    // memory stage
    wire [15:0] dataFromMemory;
    wire [15:0] MEMWB_ALU_result;
    wire [2:0] MEMWB_Rdst_address;
    wire MEMWB_memRead;
    wire MEMWB;
    MemoryStage memory_stage(ALU_result_mem,Rs_data_mem,Rd_data_mem,Rd_mem,memWrite_mem,memRead_mem,regWrite_mem,
    1'b0, //push
    1'b0, //pop
    32'b0, //sp
    32'b0, //pc
    2'b0, //counter value
    1'b0, //int signal comming from counter
    16'b0, //flag register
    dataFromMemory,MEMWB_ALU_result,MEMWB_Rdst_address,MEMWB_memRead,MEMWB,clk); // TODO : write push and pop and sp

    // register between memory and write back
    wire [15:0] dataFromMemory_WB;
    wire [15:0] ALU_result_WB;
    wire MEMWB_memRead_WB;
    reg_mem_WB reg_mem_WB(clk,dataFromMemory,ALU_result_mem,Rd_mem,memRead_mem,regWrite_mem,
    dataFromMemory_WB,ALU_result_WB,WB_address,MEMWB_memRead_WB,regWrite_WB);

    // write back stage
    write_back WriteBack(dataFromMemory_WB,ALU_result_WB,MEMWB_memRead_WB,WB_data);
endmodule