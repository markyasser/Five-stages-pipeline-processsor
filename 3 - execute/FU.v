// Forwarding Unit Module 
module FU(
    input [2:0] RsrcNew,
    input [2:0] RdestOldone,
    input [2:0] RdestOldtwo,
    input WBone,
    input WBtwo,

    output [1:0] signalsOut
    );
    assign signalsOut = 
    (RsrcNew == RdestOldone && WBone == 1) ? 2'b01 :
    (RsrcNew == RdestOldtwo && WBtwo == 1) ? 2'b10 : 2'b00;
endmodule