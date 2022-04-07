module write(PC, ALURes, MemReadDataIn, WriteRegIn, write_en, MemRead, PCNew);
  
  input [15:0]PC;
  input [31:0]ALURes;
  input [31:0]MemReadDataIn;
  input [2:0]WriteRegIn;
  input write_en;  // write enable to registers ??
  input MemRead; // signal to determine if memory data needs to be written to register
  
  output [15:0]PCNew;

  wire [31:0]read1_data, read2_data;
  wire [31:0]WriteDataOut;

  //pass values through
  assign PCNew = PC;
  
  //choose alu or memory data
  assign WriteDataOut = MemRead ? MemReadDataIn : ALURes;

  rf RF1(.clk(clk), .rst(rst), .read1_reg(3'b000), .read2_reg(3'b000), 
	     .write_reg(WriteRegIn), .write_data(WriteDataOut), .write_en(write_en), 
	     .read1_data(read1_data), .read2_data(read2_data));

  
endmodule 
