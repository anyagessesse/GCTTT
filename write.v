module write(PC, ALURes, WriteDataIn, WriteRegIn, PCOut, WriteDataOut, WriteRegOut);
  
  input [?:0]PC;
  input [31:0]ALURes;
  input [31:0]MemReadDataIn;
  input [2:0]WriteRegIn;
  
  output [?:0]PCOut;
  output [31:0]WriteDataOut;
  output [2:0]WriteRegOut;
  
endmodule 
