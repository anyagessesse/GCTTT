module write(PC, ALURes, Mem_Read, WriteDataIn, WriteRegIn, PCOut, WriteDataOut, WriteRegOut);
  
  input [12:0]PC;
  input [31:0]ALURes;
  input [31:0]MemReadDataIn;
  input [2:0]WriteRegIn;
  input Write_En_In;  // write enable to registers ??
  input Mem_Read; // signal to determine if memory data needs to be written to register
  
  output [12:0]PCOut;
  output [31:0]WriteDataOut;
  output [2:0]WriteRegOut;
  output Write_En_Out;

  //pass values through
  assign PCOut = PC;
  
  //choose alu or memory data
  assign WriteDataOut = Mem_Read ? MemReadDataIn : ALURes;

  
endmodule 
