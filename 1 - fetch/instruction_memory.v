module InstructionMemory (address, data, read, write, CS);
// Address of instruction
input [31:0] address;
// Instruction
inout [15:0] data;
// Read signal
input read;
// Write signal
input write;
// Chip select (enable)
input CS;
// 16 bit word, 2MB memory
// interrupt area ranges from [0 down to 2^5-1]
// instructions area starts from [2^5 and down to 2^20]
reg [15:0] instMemory [0:(2 ** 20 - 1)];
// Register holding the output data of the selected address
reg [15:0] dataOut;
// data wire is always connected to dataOut reg
assign data = (CS && read) ? dataOut : 16'bz;
always @(*) begin
    // Write
	if(CS && write && !read)
	begin
		instMemory[address[19:0]] = data; 
	end
    // Read
	if(CS && !write && read)
	begin
		dataOut = instMemory[address[19:0]];  
	end
end
// instMemory[address] = (CS && write && !read) ? data : instMemory[address];
// dataOut = (CS && !write && read) ?  instMemory[address] : dataOut;
endmodule