module write(PC, ALURes, MemReadDataIn, WriteRegIn, write_en, MemRead, PCNew, 
		WriteDataOut, WriteRegOut, write_en_out);
  
  input [15:0]PC;
  input [31:0]ALURes;
  input [31:0]MemReadDataIn;
  input [2:0]WriteRegIn;
  input write_en;  // write enable to registers ??
  input MemRead; // signal to determine if memory data needs to be written to register
  
  output [15:0]PCNew;
  output [31:0]WriteDataOut;
  output [2:0]WriteRegOut;
  output write_en_out;

  //pass values through
  assign PCNew = PC;
  
  //choose alu or memory data
  assign WriteDataOut = MemRead ? MemReadDataIn : ALURes;
  assign write_en_out = write_en;
  assign WriteRegOut = WriteRegIn;

  
endmodule 
