module HDU(
    input reset,
    input [2:0]Rs_decode,
    input [2:0]Rd_decode,
    input [2:0]Rdst_alu,
    input pop_flags_alu,
    input pop_pc_alu,
    input pop_alu,
    input memRead_alu,
    input jmp_decode,
    input memWrite_decode,
    input regWrite_decode,
    input out_decode,
    
    output reg load_use_case_enable,
    output mux_selector
);
always@(*)
begin 
    if(memRead_alu)
    begin
        load_use_case_enable =  ((Rdst_alu == Rs_decode || Rdst_alu == Rd_decode) && (!pop_alu && memRead_alu)) | // Load use case
                                ((Rdst_alu == Rd_decode) && pop_alu & !pop_flags_alu & memRead_alu & (jmp_decode | regWrite_decode | out_decode))| // Pop JMP | Pop ALU | Pop OUT case
                                ((Rdst_alu == Rs_decode || Rdst_alu == Rd_decode) && pop_alu & !pop_flags_alu & memRead_alu & memWrite_decode)? 0: 1; // POP STD case     
    end
    else begin 
        load_use_case_enable = 1;
    end
end
assign mux_selector = ~load_use_case_enable;
always@(posedge reset) begin
    load_use_case_enable = 1; 
end
endmodule