module control_unit(opcode,control_signals);
    input [4:0] opcode; // 5 bit op code coming from the 16 bit instruction

    output [29:0] control_signals; //assuming 8 bit control signal
    /*
    control signals :
    branch = control_signals[0]
    MemWrite = control_signals[1]
    MemRead = control_signals[2]
    WB = control_signals[3]

    RTI = control_signals[4]
    RET = control_signals[5]
    CALL = control_signals[6]
    JMP = control_signals[7]
    JC = control_signals[8]
    JN = control_signals[9]
    JZ = control_signals[10]
    STD = control_signals[11]
    LDD = control_signals[12]
    LDM = control_signals[13]
    POP = control_signals[14]
    PUSH = control_signals[15]
    SHR = control_signals[16]
    SHL = control_signals[17]
    OR = control_signals[18]
    AND = control_signals[19]
    SUB = control_signals[20]
    ADD = control_signals[21]
    MOV = control_signals[22]
    IN = control_signals[23]
    OUT = control_signals[24]
    DEC = control_signals[25]
    INC = control_signals[26]
    NOT = control_signals[27]
    CLRC = control_signals[28]
    SETC = control_signals[29]
    */

    assign control_signals = 
                        //    28|  24|  20|  16|  12|   8|   4|   0| 
    (opcode == 5'b00000)? 30'b00_0000_0000_0000_0000_0000_0000_0000:                  // NOP

    (opcode == 5'b01111)? 30'b00_0000_0000_0000_0000_0000_0001_0000:                  // RTI : rti 
    (opcode == 5'b01110)? 30'b00_0000_0000_0000_0000_0000_0010_0000:                  // RET : ret
    (opcode == 5'b01101)? 30'b00_0000_0000_0000_0000_0000_0100_0000:                  // CALL : call 

    (opcode == 5'b01000)? 30'b00_0000_0000_0000_0000_0000_1000_0001:                  // JMP : jmp + branch
    (opcode == 5'b01001)? 30'b00_0000_0000_0000_0000_0001_0000_0001:                  // JC : jc + branch 
    (opcode == 5'b01010)? 30'b00_0000_0000_0000_0000_0010_0000_0001:                  // JN : jn + branch 
    (opcode == 5'b01011)? 30'b00_0000_0000_0000_0000_0100_0000_0001:                  // JZ : jz + branch 

    (opcode == 5'b01100)? 30'b00_0000_0000_0000_0000_1000_0000_0010:                  // STD : std + memWrite
    (opcode == 5'b00111)? 30'b00_0000_0000_0000_0001_0000_0000_0100:                  // LDD : ldd + memread
    (opcode == 5'b11010)? 30'b00_0000_0000_0000_0010_0000_0000_1000:                  // LDM : ldm + WB    

    (opcode == 5'b00110)? 30'b00_0000_0000_0000_0100_0000_0000_1100:                  // POP : pop + WB + memread
    (opcode == 5'b00101)? 30'b00_0000_0000_0000_1000_0000_0000_0010:                  // PUSH : push + memWrite

    (opcode == 5'b11001)? 30'b00_0000_0000_0001_0000_0000_0000_1000:                  // SHR : shr + regWrite         
    (opcode == 5'b11000)? 30'b00_0000_0000_0010_0000_0000_0000_1000:                  // SHL : shl + regWrite         
    (opcode == 5'b10111)? 30'b00_0000_0000_0100_0000_0000_0000_1000:                  // OR  : or + regWrite     
    (opcode == 5'b10110)? 30'b00_0000_0000_1000_0000_0000_0000_1000:                  // AND : and + regWrite         
    (opcode == 5'b10101)? 30'b00_0000_0001_0000_0000_0000_0000_1000:                  // SUB : sub + regWrite  
    (opcode == 5'b10011)? 30'b00_0000_0010_0000_0000_0000_0000_1000:                  // ADD : add + regWrite         
    (opcode == 5'b10010)? 30'b00_0000_0100_0000_0000_0000_0000_1000:                  // MOV : mov + regWrite 

    (opcode == 5'b00100)? 30'b00_0000_1000_0000_0000_0000_0000_1000:                  // IN  : in + regWrite         
    (opcode == 5'b00011)? 30'b00_0001_0000_0000_0000_0000_0000_0000:                  // OUT : out         

    (opcode == 5'b10001)? 30'b00_0010_0000_0000_0000_0000_0000_1000:                  // DEC : dec + regWrite
    (opcode == 5'b10000)? 30'b00_0100_0000_0000_0000_0000_0000_1000:                  // INC : inc + regWrite
    (opcode == 5'b10100)? 30'b00_1000_0000_0000_0000_0000_0000_1000:                  // NOT : not + regWrite

    (opcode == 5'b00010)? 30'b01_0000_0000_0000_0000_0000_0000_0000:                  // CLRC : clrc 
    (opcode == 5'b00001)? 30'b10_0000_0000_0000_0000_0000_0000_0000:30'bx;            // SETC : setc 
endmodule