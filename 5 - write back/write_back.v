module write_back(dataFromMemory,dataFromAlu,memRead,WB_data);
input [15:0]dataFromMemory;
input [15:0]dataFromAlu;
input memRead;

output [15:0]WB_data;

assign WB_data = (memRead == 1'b1)? dataFromMemory: dataFromAlu;
endmodule