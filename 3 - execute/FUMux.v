module mux32(
    input [15:0] New,
    input [15:0] Oldone,
    input [15:0] Oldtwo,
    input [1:0] signalsOut,
    output [15:0] Out
    );

    assign Out =
    (signalsOut == 2'b00) ? New :
    (signalsOut == 2'b01) ? Oldone :
    (signalsOut == 2'b10) ? Oldtwo : New;
endmodule
