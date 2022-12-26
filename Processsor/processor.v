`include "../1 - fetch/fetch_stage.v"
`include "../1 - fetch/instruction_memory.v"
`include "../1 - fetch/reg_fetch_decode.v"

`include "../2 - decode/instruction_decode.v"
`include "../2 - decode/reg_decode_exec.v"
`include "../2 - decode/reg_file.v"
`include "../2 - decode/HDU.v"
`include "../2 - decode/cu_mux.v"
`include "../2 - decode/control_unit.v"
`include "../2 - decode/call_state_machine.v"

`include "../3 - execute/ALU.v"
`include "../3 - execute/mux_Src_Imm.v"
`include "../3 - execute/reg_exec_mem.v"
`include "../3 - execute/FU.v"
`include "../3 - execute/FUMux.v"

`include "../4 - memory/memory_stage.v"
`include "../4 - memory/data_memory.v"
`include "../4 - memory/reg_mem_wb.v"

`include "../5 - write back/write_back.v"

module Processor (
    input clk,
    input reg [15:0] In_Port,
    input reset,
    output reg [15:0] Out_Port
);
    reg [2:0] CCR; // flag register
    reg [31:0] PC; // PC
    // reg [15:0] In_Port;
    // reg [15:0] Out_Port;

    // fetch stage
    reg [31:0] jumpAddress;
    wire [31:0] nextInstructionAddress;
    wire isImmediate;
    wire [4:0] SHMNT;
    wire [2:0] Rd;
    wire [2:0] Rs;
    wire [4:0] opCode;
    wire [34:0] control_signals; // will be initialized in decode stage
    wire [15:0] Inst_as_Imm_value;
    wire reg_fetch_decode_enable;
    
    // if jump is true of false
    wire [15:0] dst;
    wire [34:0] control_signals_execute;
    wire OrCCR;
    reg branchResult;
    reg unconditionalJump;
    reg Return;
    
    assign OrCCR = CCR[0] | CCR[1] | CCR[2];
    wire [1:0]shmnt_WB;
    wire pop_WB;
    reg [1:0]shmnt_WB_reg;
    reg pop_WB_reg;
    wire [15:0] WB_data;    // will be initiallized from write back (down)
    initial begin
        branchResult = 0; 
        unconditionalJump = 0; 
        shmnt_WB_reg = 0;
        pop_WB_reg = 0;
        Return = 0;
    end
    always@(*)begin 
        branchResult = OrCCR & control_signals_execute[0];
        unconditionalJump = control_signals_execute[7];
        Return = control_signals_execute[33];
        shmnt_WB_reg = shmnt_WB;
        pop_WB_reg = pop_WB;
    end
    wire [31:0] PC_wire;
    wire reg_FD_enable_callStateMachine;
    // wire enable_if_call;
    
    wire popPc_WB,popCCR_WB;
    wire [2:0]  Rd_decode;  

    wire pc_enable_call;
    assign pc_enable_call = !(control_signals[30] | control_signals[31] | control_signals[32] | control_signals[33] | control_signals[34]);
    //FetchStage Fetch(reg_fetch_decode_enable,32'b0,32'b0,isImmediate,nextInstructionAddress,SHMNT,Rd,Rs,opCode,control_signals[13],Inst_as_Imm_value,clk);
    FetchStage Fetch(pc_enable_call & reg_fetch_decode_enable,32'b0,{16'b0,dst},isImmediate,nextInstructionAddress,SHMNT,Rd,Rs,opCode,control_signals[13],Inst_as_Imm_value,clk,
    reset,
    1'b0,
    control_signals[31],
    control_signals[30],
    control_signals[32],
    control_signals[33],
    Return,
    Rd_decode,
    popPc_WB & pop_WB_reg, // selector of the pop pc (return)
    branchResult,
    unconditionalJump,
    {16'b0,WB_data},
    PC_wire
    );
    always @(*) begin PC = PC_wire; end
    // register between fetch and decode
    wire [31:0] Next_inst_addr_decode;
    wire [4:0]  opcode_decode;
    wire [2:0]  Rs_decode;
    
    wire [4:0]  shmnt_decode;
    wire [31:0]  pc_decode;

    // wire[34:0] controlSignals_Call;

    
    // CallStateMachine callStateMachine(clk,reset,opCode,controlSignals_Call,reg_FD_enable_callStateMachine);

    wire[35:0] control_signals_if_call_decode;
    reg_fetch_decode reg_fetch_decode(clk,reg_fetch_decode_enable,nextInstructionAddress,opCode,Rs,Rd,SHMNT,PC,
    Next_inst_addr_decode,opcode_decode,Rs_decode,Rd_decode,shmnt_decode,pc_decode);

    // decode stage
    
    wire [2:0] WB_address;  // will be initiallized from write back (down)
    wire regWrite_WB;       // will be initiallized from write back (down)
    wire WB_signal_if_not_ret;
    wire [2:0] Rd_execute;
    reg rst;
    // reg rstAll;
    wire [15:0] Rs_data;
    wire [15:0] Rd_data;
    
    wire HDU_mux_selector;
    HDU hdu(Rs_decode,Rd_decode,Rd_execute,control_signals_execute[14],control_signals_execute[2],reg_fetch_decode_enable,HDU_mux_selector);
    wire [4:0]cu_opcode;
    wire cu_mux_selector;
    assign cu_mux_selector = HDU_mux_selector | branchResult | unconditionalJump | Return;
    cu_mux cu_mux(opcode_decode,cu_mux_selector,cu_opcode);
    control_unit CU(cu_opcode,control_signals);

    // wire[34:0] controlSignals_Call;
    // CallStateMachine callStateMachine(clk,reset,opcode_decode,controlSignals_Call,reg_FD_enable_callStateMachine);
    // assign enable_if_call = (opcode_decode == 5'b01101) ? 1'b0: 1'b1;
    
    // wire[34:0] controlSignals_muxOut;
    // assign controlSignals_muxOut = (opcode_decode==5'b01101)? controlSignals_Call : control_signals;
    
    RegFile registers(WB_signal_if_not_ret,Rs_decode,Rd_decode,Rs_data,Rd_data,WB_data,clk,rst,reset,WB_address); 
    
    // register between decode and execute
    wire [15:0]Imm_value_execute;
    wire [4:0]shmnt_execute;
    wire [15:0]Rs_data_execute;
    wire [2:0]Rs_execute;
    wire [15:0]Rd_data_execute;
    
    reg_decode_exec reg_dec_exec(clk,Inst_as_Imm_value,shmnt_decode,Rs_data,Rd_data,Rd_decode,control_signals,Rs_decode,
    Imm_value_execute,shmnt_execute,Rs_data_execute,Rd_data_execute,Rd_execute,control_signals_execute,Rs_execute);

    // execute stage
    wire [15:0] ALU_Result; // ALU 16-bit Output
    wire [2:0] ccr_out; // flags register
    wire [15:0] src_from_mux; // ALU source
    mux21 mux2x1(Rs_data_execute,Imm_value_execute,control_signals_execute[13],src_from_mux);

    wire [15:0] ALU_result_mem; // ALU RESULT FROM MEMORY STAGE
    wire [2:0] Rd_mem; // Rd from memory stage
    // WB_address is Rd from WB stage
    wire  regWrite_mem; //regWrite_WB is WB signal from WB stage
    // regWrite_mem is WB signal from memory stage
    wire [1:0]selectorFU_src;
    wire [1:0]selectorFU_dst;
    FU forwaringUnit(Rs_execute,Rd_execute,Rd_mem,WB_address,regWrite_mem,regWrite_WB,selectorFU_src,selectorFU_dst);

    wire [15:0] src;
    mux32 muxForwarding_Src(src_from_mux,ALU_result_mem,WB_data,selectorFU_src,src); 
    mux32 muxForwarding_Dst(Rd_data_execute,ALU_result_mem,WB_data,selectorFU_dst,dst); 
    ALU alu(src,dst,shmnt_execute,
    control_signals_execute[22],
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
    control_signals_execute[13],
    ALU_Result,ccr_out,In_Port);

    // write to OUT port
    wire [15:0] dst_to_out_port;
    assign  dst_to_out_port = dst;
    always @(dst_to_out_port)begin 
        if(control_signals_execute[24] == 1)begin

        Out_Port = dst_to_out_port;
        end
    end
    wire return_CCR;
    assign return_CCR = popCCR_WB & pop_WB_reg;
    always @(*) begin if(
    control_signals_execute[21] == 1 ||
    control_signals_execute[27] == 1 ||
    control_signals_execute[26] == 1 ||
    control_signals_execute[25] == 1 ||
    control_signals_execute[20] == 1 ||
    control_signals_execute[19] == 1 ||
    control_signals_execute[18] == 1 ||
    control_signals_execute[17] == 1 ||
    control_signals_execute[16] == 1 ||
    control_signals_execute[13] == 1 ||
    return_CCR == 1)begin CCR = (return_CCR == 1)? WB_data : ccr_out; end end

    // register between execute and memory
    wire [15:0] Rs_data_mem;
    wire [15:0] Rd_data_mem;
    wire  memRead_mem;
    wire  memWrite_mem;
    wire  push_mem;
    wire  pop_mem;
    wire [1:0]shmnt_mem;
    wire pushPc_mem;
    wire popPc_mem;
    wire pushCCR_mem;
    wire popCCR_mem;
    reg_exec_mem reg_exec_mem(
        // input
        clk,ALU_Result,src,dst,Rd_execute,control_signals_execute[2],control_signals_execute[1],control_signals_execute[3],
        control_signals_execute[15],
        control_signals_execute[14],
        shmnt_execute[1:0],
        control_signals_execute[30],
        control_signals_execute[32],
        control_signals_execute[31],
        control_signals_execute[33],
        // output
    ALU_result_mem,Rs_data_mem,Rd_data_mem,Rd_mem,memRead_mem,memWrite_mem,regWrite_mem, 
    push_mem,
    pop_mem,
    shmnt_mem,
    pushPc_mem,
    popPc_mem,
    pushCCR_mem,
    popCCR_mem
    );

    // memory stage
    wire [15:0] dataFromMemory;
    wire [15:0] MEMWB_ALU_result;
    wire [2:0] MEMWB_Rdst_address;
    wire MEMWB_memRead;
    wire MEMWB;
    MemoryStage memory_stage(shmnt_mem,ALU_result_mem,Rs_data_mem,Rd_data_mem,Rd_mem,memWrite_mem,memRead_mem,regWrite_mem,
    push_mem, //push
    pop_mem,  //pop
    pushPc_mem,
    pushCCR_mem,
    pc_decode[15:0],    // pc to be writen if push PC occured (CALL instruction)
    2'b0,  //counter value
    1'b0,  //int signal comming from counter
    CCR, //flag register
    dataFromMemory,MEMWB_ALU_result,MEMWB_Rdst_address,MEMWB_memRead,MEMWB,clk); // TODO : write push and pop and sp

    // register between memory and write back
    wire [15:0] dataFromMemory_WB;
    wire [15:0] ALU_result_WB;
    wire MEMWB_memRead_WB;
    
    
    reg_mem_WB reg_mem_WB(clk,dataFromMemory,ALU_result_mem,Rd_mem,memRead_mem,regWrite_mem,shmnt_mem,pop_mem,popPc_mem,popCCR_mem,
    dataFromMemory_WB,ALU_result_WB,WB_address,MEMWB_memRead_WB,regWrite_WB,shmnt_WB,pop_WB,popPc_WB,popCCR_WB);
    
    assign WB_signal_if_not_ret = ((popPc_WB | popCCR_mem)  & pop_WB)?0:regWrite_WB;
    // assign WB_signal_if_not_ret = ((shmnt_WB[0] | shmnt_WB[1])  & pop_WB)?0:regWrite_WB;
    // write back stage
    write_back WriteBack(dataFromMemory_WB,ALU_result_WB,MEMWB_memRead_WB,WB_data);
endmodule