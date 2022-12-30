`include "../1 - fetch/fetch_stage.v"
`include "../1 - fetch/instruction_memory.v"
`include "../1 - fetch/reg_fetch_decode.v"

`include "../2 - decode/instruction_decode.v"
`include "../2 - decode/reg_decode_exec.v"
`include "../2 - decode/reg_file.v"
`include "../2 - decode/HDU.v"
`include "../2 - decode/cu_mux.v"
`include "../2 - decode/control_unit.v"

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
    input int,
    output reg [15:0] Out_Port
);
    reg [2:0] CCR; // CPU Flag register
    reg [31:0] PC; // CPU PC
    reg [31:0] SP; // CPU SP
//###########################################################################################################
//################################################# Wires ###################################################
//###########################################################################################################
    
    //------------------interrupt wires------------------
    reg interrupt;
    wire int1_decode;
    wire int1_execute;
    wire int1_mem;
    wire int1_WB;
    wire int2_decode;
    wire int2_execute;
    wire int2_mem;
    wire int2_WB; // this signal will be the enable of the interrupt signal to jump to address 0 instead of Rdst


    //------------------fetch------------------
    wire [31:0] nextInstructionAddress;
    wire isImmediate;
    wire [4:0] SHMNT;
    wire [2:0] Rd;
    wire [2:0] Rs;
    wire [4:0] opCode;
    wire reg_fetch_decode_enable;
    wire [31:0] PC_wire;
    wire pc_enable_call; // the enable of the PC which is the oring of the 8 signals in the fetch stage design


    //------------------decode------------------
    wire [31:0] Next_inst_addr_decode;
    wire [15:0] Inst_as_Imm_value;    // has the instruction that represents the immediate value
    wire [31:0] pc_decode;
    wire [4:0]  opcode_decode;
    wire [2:0]  Rd_decode; 
    wire [2:0]  Rs_decode;
    wire [4:0]  shmnt_decode;
    wire [15:0] Rs_data;
    wire [15:0] Rd_data;
    wire HDU_mux_selector; // This wire is the output of the HDU
    wire [4:0]cu_opcode;   // represents the wire that enters the Control Unit
    wire cu_mux_selector;  // represents the selector of the mux before the Control Unit
    wire [34:0] control_signals; // Control Signals of the decode stage


    //------------------execute------------------
    wire [34:0] control_signals_execute; 
    wire [15:0]Imm_value_execute; // Immediate value forwarded from Fetch stage
    wire [4:0]shmnt_execute;
    wire [15:0]Rs_data_execute;
    wire [2:0]Rs_execute;
    wire [2:0]Rd_execute;
    wire [15:0]Rd_data_execute;
    wire return_CCR; // selector that returns the value of CCR after pop flags
    wire [15:0] ALU_Result; // ALU 16-bit Output
    wire [2:0] ccr_out; // flags register
    wire [15:0] src_from_mux; // the output of the mux that selects either Rs data execute OR Immediate value
    wire [1:0]selectorFU_src; // output of the FU for source
    wire [1:0]selectorFU_dst; // output of the FU for destination
    wire [15:0] dst_to_out_port; // the data to be writen to output port
    wire [15:0] dst; // The 1st input of the ALU
    wire [15:0] src; // The 2nd input of the ALU
    wire OrCCR; // Oring of the 3 bit of the CCR
    reg branchResult; // Oring of the 3 bit of the CCR anded with the branch singal
    reg unconditionalJump;
    reg Return; // return signal in the execute
    wire [31:0]jumpAddress; // JMP address from execute stage

    //------------------memory------------------
    wire [15:0] Rs_data_mem;
    wire [15:0] Rd_data_mem;
    wire memRead_mem;
    wire memWrite_mem;
    wire push_mem;
    wire pop_mem;
    wire [1:0]shmnt_mem;
    wire pushPc_mem;
    wire popPc_mem;
    wire pushCCR_mem;
    wire popCCR_mem;
    wire [15:0] ALU_result_mem; // ALU RESULT FROM MEMORY STAGE
    wire [2:0] Rd_mem; // Rd from memory stage
    wire regWrite_mem; //regWrite_WB is WB signal from WB stage
    wire [15:0] MEMWB_ALU_result; // the ALU output at the memory stage 
    wire [15:0] dataFromMemory; // the Read data from memory
    wire [2:0] MEMWB_Rdst_address; // Rd data as address at memory stage
    wire MEMWB_memRead;
    wire MEMWB; 
    wire [31:0] SP_wire;


    //------------------write back------------------
    wire [1:0]shmnt_WB;
    wire popPc_WB,popCCR_WB;
    wire pop_WB;
    reg [1:0]shmnt_WB_reg;
    reg pop_WB_reg;
    wire [15:0] WB_data;  
    wire [2:0] WB_address;  
    wire regWrite_WB;       
    wire WB_signal_if_not_ret;
    wire [15:0] dataFromMemory_WB;
    wire [15:0] ALU_result_WB;
    wire MEMWB_memRead_WB;
   



//###########################################################################################################
//############################################## INITIALIZE #################################################
//###########################################################################################################
    assign OrCCR = CCR[0] | CCR[1] | CCR[2];
    assign return_CCR = popCCR_WB & pop_WB_reg;
    assign  dst_to_out_port = dst;
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
    always @(posedge clk,posedge int) begin 
        if(interrupt == 1)begin interrupt = 0; end
        else begin interrupt = int; end
    end
    always @(*) begin PC = PC_wire; end
    always @(*) begin SP = SP_wire; end
    always@(posedge reset) begin
        branchResult = 0; 
        unconditionalJump = 0; 
        shmnt_WB_reg = 0;
        pop_WB_reg = 0;
        Return = 0;
        CCR = 0;
    end
    always@(*)begin 
        branchResult = OrCCR & control_signals_execute[0];
        unconditionalJump = control_signals_execute[7];
        Return = control_signals_execute[33];
        shmnt_WB_reg = shmnt_WB;
        pop_WB_reg = pop_WB;
    end
    always @(dst_to_out_port)begin 
        if(control_signals_execute[24] == 1)begin
            Out_Port = dst_to_out_port;
        end
    end
//###########################################################################################################
//############################################### FETCH STAGE ###############################################
//###########################################################################################################
    assign pc_enable_call = !(control_signals[30] | control_signals[31] | control_signals[32] | control_signals[33] | control_signals[34] 
                            | interrupt | int1_decode | int1_execute | int1_mem | int1_WB)  | popPc_WB | branchResult | unconditionalJump;
    assign jumpAddress = (int2_WB == 1'b1)? 0:{16'b0,dst};
    FetchStage Fetch(
        clk,
        pc_enable_call & reg_fetch_decode_enable, // enable of the PC
        jumpAddress,  // JMP address
        isImmediate,  // the is a selector to make nop if the instruction inside the decode now is an Imm value
        nextInstructionAddress, // address of the next instruction
        SHMNT,Rd,Rs,opCode,  // instruction from the fetch stage
        control_signals[13], // LDM signal from decode stage used in the LDM case
        Inst_as_Imm_value,   // the current instruction but will be usefull only on LDM case
        reset,    // CPU reset signal
        interrupt, // CPU interrupt signal
        int1_decode, // CPU interrupt signal from decode stage
        int1_execute, // CPU interrupt signal from execute stage
        int1_mem, // CPU interrupt signal from memory stage
        int1_WB, // CPU interrupt signal from WB stage
        control_signals[31], // signal push flags from decode
        control_signals[30], // signal push pc from decode
        control_signals[32], // signal pop pc from decode
        control_signals[33], // signal pop flags from decode
        Return, // signal pop flags from execute used to make the second nop after return
        Rd_decode, // Rdst from decode to JMP Rdst on CALL Rdst
        popPc_WB & pop_WB_reg, // selector of the pop pc (return)
        branchResult, 
        unconditionalJump,
        {16'b0,WB_data}, // The new PC after POP PC
        PC_wire // PC output from Fetch stage
    );
    reg_fetch_decode reg_fetch_decode(clk,interrupt,
        reg_fetch_decode_enable,
        nextInstructionAddress,opCode,Rs,Rd,SHMNT,PC,interrupt,int1_WB,
        Next_inst_addr_decode,opcode_decode,Rs_decode,Rd_decode,shmnt_decode,pc_decode,int1_decode,int2_decode);

//###########################################################################################################
//############################################## DECODE STAGE ###############################################
//###########################################################################################################
    

    HDU hdu(Rs_decode,Rd_decode,Rd_execute,
        control_signals_execute[32], // if the inst in the exec is pop flags to avoid confusion with ret
        control_signals_execute[33], // if the inst in the exec is pop pc to avoid confusion with ret
        control_signals_execute[14], // if the inst in the exec is pop 
        control_signals_execute[2],  // if the inst in the exec is mem read
        control_signals[7] | control_signals[8] | control_signals[9] | control_signals[10], // if any jump in decode
        control_signals[1],
        control_signals[3],
        control_signals[24],
        reg_fetch_decode_enable,
        HDU_mux_selector);
    assign cu_mux_selector = HDU_mux_selector | branchResult | unconditionalJump | Return;
    cu_mux cu_mux(opcode_decode,cu_mux_selector,cu_opcode);
    control_unit CU(cu_opcode,control_signals);
    RegFile registers(WB_signal_if_not_ret,Rs_decode,Rd_decode,Rs_data,Rd_data,WB_data,clk,reset,WB_address); 
    reg_decode_exec reg_dec_exec(clk,Inst_as_Imm_value,shmnt_decode,Rs_data,Rd_data,Rd_decode,control_signals,Rs_decode,int1_decode,int2_decode,
        Imm_value_execute,shmnt_execute,Rs_data_execute,Rd_data_execute,Rd_execute,control_signals_execute,Rs_execute,int1_execute,int2_execute);
        

//############################################## EXECUTE STAGE ###############################################
//##########################################################################################################
//###########################################################################################################
    FU forwaringUnit(Rs_execute,Rd_execute,Rd_mem,WB_address,regWrite_mem,regWrite_WB,selectorFU_src,selectorFU_dst);
    mux21 mux2x1(Rs_data_execute,Imm_value_execute,control_signals_execute[13],src_from_mux);
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
    reg_exec_mem reg_exec_mem(
        // inputs
        clk,ALU_Result,src,dst,Rd_execute,control_signals_execute[2],control_signals_execute[1],control_signals_execute[3],
        control_signals_execute[15],
        control_signals_execute[14],
        shmnt_execute[1:0],
        control_signals_execute[30],
        control_signals_execute[32],
        control_signals_execute[31],
        control_signals_execute[33],
        int1_execute,
        int2_execute,
        // outputs
        ALU_result_mem,Rs_data_mem,Rd_data_mem,Rd_mem,memRead_mem,memWrite_mem,regWrite_mem, 
        push_mem,
        pop_mem,
        shmnt_mem,
        pushPc_mem,
        popPc_mem,
        pushCCR_mem,
        popCCR_mem,
        int1_mem,
        int2_mem
    );

//###########################################################################################################
//############################################## MEMORY STAGE ###############################################
//###########################################################################################################
    MemoryStage memory_stage(shmnt_mem,ALU_result_mem,Rs_data_mem,Rd_data_mem,Rd_mem,memWrite_mem,memRead_mem,regWrite_mem,
        push_mem, //push
        pop_mem,  //pop
        pushPc_mem,
        pushCCR_mem,
        pc_decode[15:0],    // pc to be writen if push PC occured (CALL instruction)
        CCR, //flag register
        dataFromMemory,MEMWB_ALU_result,MEMWB_Rdst_address,MEMWB_memRead,MEMWB,SP_wire,clk);
    reg_mem_WB reg_mem_WB(clk,dataFromMemory,ALU_result_mem,Rd_mem,memRead_mem,regWrite_mem,shmnt_mem,pop_mem,popPc_mem,popCCR_mem,int1_mem,int2_mem,
    dataFromMemory_WB,ALU_result_WB,WB_address,MEMWB_memRead_WB,regWrite_WB,shmnt_WB,pop_WB,popPc_WB,popCCR_WB,int1_WB,int2_WB);
    
    //###########################################################################################################
    //########################################### WRITE BACK STAGE ##############################################
    //###########################################################################################################
    assign WB_signal_if_not_ret = ((popPc_WB | popCCR_WB)  & pop_WB)? 0:regWrite_WB;
    write_back WriteBack(dataFromMemory_WB,ALU_result_WB,MEMWB_memRead_WB,WB_data);
endmodule