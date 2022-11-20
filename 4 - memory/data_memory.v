module DataMemory (address, data, read, write, CS);
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
// 16 bit word, 4KB memory
// The data memory starts with the data area (the very first address space and down)
// Followed by the stack area (starting from [2^11−1 and up])
reg [15:0] dataMem [0:(2 ** 11 - 1)];
// Register holding the output data of the selected address
reg [15:0] dataOut;
// data wire is always connected to dataOut reg
assign data = (CS && read) ? dataOut : 16'bz;
always @(*) begin
    // Write
	if(CS && write && !read)
	begin
		dataMem[address[10:0]] = data; 
	end
    // Read
	if(CS && !write && read)
	begin
		dataOut = dataMem[address[10:0]];  
	end
end
// dataMem[address] = (CS && write && !read) ? data : dataMem[address];
// dataOut = (CS && !write && read) ?  instMemory[address] : dataOut;
endmodule