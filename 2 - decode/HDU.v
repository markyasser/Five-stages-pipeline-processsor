module HDU(
    input [2:0]Rs_decode,
    input [2:0]Rd_decode,
    input [2:0]Rdst_alu,
    input pop_alu,
    input memRead_alu,
    output reg load_use_case_enable,
    output mux_selector
);
always@(*)
begin 
    load_use_case_enable = ((Rdst_alu == Rs_decode || Rdst_alu == Rd_decode) && (!pop_alu && memRead_alu))? 0: 1;
end
assign mux_selector = ~load_use_case_enable;

initial begin load_use_case_enable = 1; end
endmodule