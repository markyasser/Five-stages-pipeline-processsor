module HDU(
    input [2:0]Rs_decode,
    input [2:0]Rd_decode,
    input [2:0]Rdst_alu,
    input pop_alu,
    input memRead_alu,
    input jmp_decode,
    
    output reg load_use_case_enable,
    output mux_selector
);
always@(memRead_alu)
begin 
    load_use_case_enable =  ((Rdst_alu == Rs_decode || Rdst_alu == Rd_decode) && (!pop_alu && memRead_alu)) | // Load use case
                            ((Rdst_alu == Rd_decode) && pop_alu & memRead_alu & jmp_decode)? 0: 1;          // Pop JMP case
end
assign mux_selector = ~load_use_case_enable;
initial begin
    load_use_case_enable = 1; end
endmodule




module PopDataHazard (
    input [2:0]Rd_execute,
    input [2:0]Rd_decode,
    input pop_exec,
    input memRead_exec,
    input jmp_decode,

    output reg pop_case,
    output mux_selector_pop_case

);
always @(pop_exec) begin
        pop_case = ((Rd_execute == Rd_decode) && pop_exec & memRead_exec & jmp_decode)? 0:1;
end
assign mux_selector_pop_case = ~pop_case;
        initial begin
            pop_case = 1;
        end
endmodule