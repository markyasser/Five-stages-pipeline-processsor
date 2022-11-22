module control_unit(opcode,control_signals);
    input [4:0] opcode; // 5 bit op code coming from the 16 bit instruction

    output [7:0] control_signals; //assuming 8 bit control signal
    /*
    control signals :
    not = control_signals[0]
    add = control_signals[1]
    memRead = control_signals[2]
    memWrite = control_signals[3]
    regWrite = control_signals[4]
    ldm = control_signals[5]
    */

    assign control_signals = 
    (opcode == 5'b00_001)? 8'b0011_0000:                  // LDM : ldm + regWrite    
    (opcode == 5'b00_010)? 8'b0000_1000:                  // STD : memWrite
    (opcode == 5'b00_011)? 8'b0001_0010:                  // ADD : add + regWrite         
    (opcode == 5'b00_100)? 8'b0001_0001:                  // NOT : not + regWrite
    (opcode == 5'b00_101)? 8'b0 : 8'bx;                   // NOP
endmodule




