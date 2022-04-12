module memory(flush, RdRqIn, ALURes, Mem_Write, MemRead,
		ALUOut, WriteRegDataOut);

    //input [15:0]PC;
    input flush;
    input [31:0]RdRqIn;
    input [31:0]ALURes;
    input Mem_Write;	//1 = write to memory
    input MemRead;
    input [31:0]MemReadDataIn;

    //output [15:0]PCOut;
    output [31:0]ReadDataOut;
    output [31:0]ALUOut;
    output [31:0]WriteRegDataOut;


    wire [15:0]data_imm;
    wire [31:0]MemDataOut;
    //pass signals through to next stage
    assign ALUOut = ALURes;
    assign MemDataOut = {16'h0000, data_imm};

    assign WriteRegDataOut = MemRead ? MemDataOut : ALURes;

    //memory stuff here :) use WriteDataIn, ALURes, Mem_Write
    memory2c MEM0(.data_out(data_imm), .data_in(RdRqIn[15:0]), .addr(ALURes[15:0]), .enable(1'b1), .wr(MemWrite), .createdump(1'b0), .clk(clk), .rst(rst));

  
endmodule
