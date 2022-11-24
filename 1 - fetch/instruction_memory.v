module InstructionMemory (address, writeData, readData, read, write, CS, clk);
// Address of instruction
input [31:0] address;
// Instruction
input [15:0] writeData;
output reg [15:0] readData;
// Read signal
input read;
// Write signal
input write;
// Chip select (enable)
input CS;
// Clock
input clk;
// 16 bit word, 2MB memory
// interrupt area ranges from [0 down to 2^5-1]
// instructions area starts from [2^5 and down to 2^20]
reg [15:0] instMemory [0:(2 ** 20 - 1)];
initial begin
	instMemory[2 ** 5]	   = 16'b00001_000_001_00000;	// LDM R1,Imm -> 	R1 = 0
	instMemory[2 ** 5 + 1] = 16'h0;						// Imm value
	instMemory[2 ** 5 + 2] = 16'b00001_000_010_00000;	// LDM R2,Imm -> 	R2 = 2
	instMemory[2 ** 5 + 3] = 16'h2;						// Imm value

	instMemory[2 ** 5 + 4] = 16'b00101_000_000_00000;	// NOP
	instMemory[2 ** 5 + 5] = 16'b00101_000_000_00000;	// NOP

	instMemory[2 ** 5 + 6] = 16'b00011_010_001_00000;	// ADD R2,R1 -> 	R1 = 0000_0000_0000_0010

	instMemory[2 ** 5 + 7] = 16'b00101_000_000_00000;	// NOP
	instMemory[2 ** 5 + 8] = 16'b00101_000_000_00000;	// NOP

	instMemory[2 ** 5 + 9] = 16'b00100_001_001_00000;	// NOT R1 	 ->		R1 = 1111_1111_1111_1101

	instMemory[2 ** 5 + 10] = 16'b00101_000_000_00000;	// NOP
	instMemory[2 ** 5 + 11] = 16'b00101_000_000_00000;	// NOP

	instMemory[2 ** 5 + 12] = 16'b00010_010_001_00000;	// STD R2,R1 -> Mem[R1 = 1111_1111_1111_1101()] = R2(2)
end
always @(posedge clk) begin
    // Write
	if(CS && write && !read)
	begin
		instMemory[address[19:0]] = writeData; 
	end
end
// always @(CS or address or read) begin
always @(*) begin
	// Read
	if(CS && !write && read)
	begin
		readData = instMemory[address[19:0]];  
	end
end
// instMemory[address] = (CS && write && !read) ? data : instMemory[address];
// dataOut = (CS && !write && read) ?  instMemory[address] : dataOut;
endmodule