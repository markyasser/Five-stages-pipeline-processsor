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
	instMemory[2 ** 5] = 16'b00011_001_010_00000;
	instMemory[2 ** 5 + 1] = 16'b00100_100_011_00000;
	instMemory[2 ** 5 + 2] = 16'b00010_110_101_00000;
	instMemory[2 ** 5 + 3] = 16'b00100_001_010_00000;
	instMemory[2 ** 5 + 4] = 16'b00101_000_001_00000;
end
always @(posedge clk) begin
    // Write
	if(CS && write && !read)
	begin
		instMemory[address[19:0]] = writeData; 
	end
 
end
always @(CS or address or read) begin
	// Read
	if(CS && !write && read)
	begin
		readData = instMemory[address[19:0]];  
	end
end
// instMemory[address] = (CS && write && !read) ? data : instMemory[address];
// dataOut = (CS && !write && read) ?  instMemory[address] : dataOut;
endmodule