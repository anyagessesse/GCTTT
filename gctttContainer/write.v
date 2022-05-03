module write(ALURes, WriteDataIn, MemRead, read_coord, grid_coord, FinalRegWriteData);
  
  //input [15:0]PC;
  input [31:0]ALURes;
  input [31:0]WriteDataIn;
  input MemRead; // signal to determine if memory data needs to be written to register
  input read_coord;
  input [3:0]grid_coord;

  output [31:0]FinalRegWriteData;
  
  //output [15:0]PCNew;

  assign FinalRegWriteData = read_coord ? {27'b0,grid_coord} : WriteDataIn;
  

  //pass values through
 // assign PCNew = PC;
  
  //choose alu or memory data

  
endmodule 
