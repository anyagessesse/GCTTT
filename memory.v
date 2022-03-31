module memory(PC, flush, RdRq, ALURes, Mem_Write,
		PCOut, ReadDataOut, ALUOut, Mem_Read_Out);

    input [12:0]PC;
    input flush;
    input [31:0]RdRq;
    input [31:0]ALURes;
    input Mem_Write;	//1 = write to memory

    output [12:0]PCOut;
    output [31:0]ReadDataOut;
    output [31:0]ALUOut;
    output Mem_Read_Out;


    //pass signals through to next stage
    assign PCOut = PC;
    assign ALUOut = ALURes;

    //memory stuff here :) use WriteDataIn, ALURes, Mem_Write
    memory2c MEM0(.data_out(readData), .data_in(writeData), .addr(address), .enable(1'b1), .wr(MemWrite), .createdump(1'b0), .clk(clk), .rst(rst));

  
endmodule
