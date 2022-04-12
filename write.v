module write(ALURes, MemReadDataIn, MemRead);
  
  //input [15:0]PC;
  input [31:0]ALURes;
  input [31:0]MemReadDataIn;
  input MemRead; // signal to determine if memory data needs to be written to register
  
  //output [15:0]PCNew;

  wire [31:0]read1_data, read2_data;
  wire [31:0]WriteDataOut;

  //pass values through
 // assign PCNew = PC;
  
  //choose alu or memory data

  
endmodule 
