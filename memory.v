module memory(PC, flush, RdRq, ALURes, PCOut, DataOut, ALUOut);

    input [?:0]PC;
    input flush;
    input [31:0]WriteDataIn;
    input [31:0]ALURes;
    input WriteEn;

    output [?:0]PCOut;
    output [31:0]ReadDataOut;
    output [31:0]ALUOut;
  
endmodule
