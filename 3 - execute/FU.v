// Forwarding Unit Module 
module FU(
    input [2:0] RsrcNew,
    input [2:0] RdstNew,
    input [2:0] RdestOldone,
    input [2:0] RdestOldtwo,
    input WBone,
    input WBtwo,

    output [1:0] selector_src,
    output [1:0] selector_dst
    );
    assign selector_src = 
    (RsrcNew == RdestOldone && WBone == 1) ? 2'b01 :
    (RsrcNew == RdestOldtwo && WBtwo == 1) ? 2'b10 : 2'b00;

    assign selector_dst = 
    (RdstNew == RdestOldone && WBone == 1) ? 2'b01 :
    (RdstNew == RdestOldtwo && WBtwo == 1) ? 2'b10 : 2'b00;
endmodule