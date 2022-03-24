module memory(PC, flush, RdRq, ALURes, PCOut, DataOut, ALUOut);

    input [?:0]PC;
    input flush;
    input [31:0]RdRq;
    input [31:0]ALURes;

    output [?:0]PCOut;
    output [31:0]DataOut;
    output [31:0]ALUOut;
  
endmodule
