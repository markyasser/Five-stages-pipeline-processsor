module HDU(
    input [2:0]Rs_decode,
    input [2:0]Rd_decode,
    input [2:0]Rdst_alu,
    input pop_alu,
    input memRead_alu,
    output reg load_use_case_enable,
    // output reg pop_case,
    output mux_selector
    // output mux_selector_pop_case
);
always@(*)
begin 
    load_use_case_enable = ((Rdst_alu == Rs_decode || Rdst_alu == Rd_decode) && (!pop_alu && memRead_alu))? 0: 1;
    // pop_case = ((Rdst_alu == Rd_decode) && (pop_alu && memRead_alu) && )?0:1;
end
assign mux_selector = ~load_use_case_enable;
// assign mux_selector_pop_case = ~pop_case;


initial begin
    //  pop_case = 1;
 load_use_case_enable = 1; end
endmodule

module PopDataHazard (
    input [2:0]Rd_execute,//of jump
    input [2:0]Rd_mem,//of pop
    input pop_mem,
    input memRead_mem,
    input jmp,

    output reg pop_case,
    output mux_selector_pop_case

);
always @(*) begin
        pop_case = ((Rd_execute == Rd_mem) && (pop_mem && memRead_mem) && jmp)?0:1;
end
assign mux_selector_pop_case = ~pop_case;
    initial begin
        pop_case = 1;
    end
endmodule