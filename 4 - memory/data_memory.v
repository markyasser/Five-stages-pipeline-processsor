module DataMemory (address, writeData, readData, read, write, CS, clk, push);
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
// Clock
input clk;
input push;
// 16 bit word, 4KB memory
// The data memory starts with the data area (the very first address space and down)
// Followed by the stack area (starting from [2^11−1 and up])
reg [15:0] dataMem [0:(2 ** 11 - 1)];

always @(negedge clk,write,push) begin // asssuming write is a HW signal
    // Write
	if(CS && write && !read)
	begin
		dataMem[address[10:0]] = writeData; 
	end
end
always @(*) begin
	// Read
	if(CS && !write && read)
	begin
		readData = dataMem[address[10:0]];  
	end
end
// dataMem[address] = (CS && write && !read) ? data : dataMem[address];
// dataOut = (CS && !write && read) ?  instMemory[address] : dataOut;
endmodule