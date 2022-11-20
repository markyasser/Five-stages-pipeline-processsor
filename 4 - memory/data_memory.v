module DataMemory (address, writeData, readData, read, write, CS);
// Address of data
input [31:0] address;
input [15:0] writeData;
output reg [15:0] readData;
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
// data wire is always connected to dataOut reg
always @(*) begin
    // Write
	if(CS && write && !read)
	begin
		dataMem[address[10:0]] = writeData; 
	end
    // Read
	if(CS && !write && read)
	begin
		readData = dataMem[address[10:0]];  
	end
end
// dataMem[address] = (CS && write && !read) ? data : dataMem[address];
// dataOut = (CS && !write && read) ?  instMemory[address] : dataOut;
endmodule