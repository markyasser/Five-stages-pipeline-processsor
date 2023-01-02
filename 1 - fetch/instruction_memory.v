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
  initial
  begin
    // $readmemb("../assembler/binary.txt", instMemory);
    $readmemb("D:/CMP/third_Year/first_Semester/computer architecture/project/Five-stages-pipeline-processsor/assembler/binary.txt", instMemory);
  end
  always @(posedge clk)
  begin
    // Write
    if(CS && write && !read)
    begin
      instMemory[address[19:0]] = writeData;
    end
  end
  // always @(CS or address or read) begin
  always @(*)
  begin
    // Read
    if(CS && !write && read)
    begin
      readData = instMemory[address[19:0]];
    end
  end
  // instMemory[address] = (CS && write && !read) ? data : instMemory[address];
  // dataOut = (CS && !write && read) ?  instMemory[address] : dataOut;
endmodule
