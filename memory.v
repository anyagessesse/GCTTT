module memory(flush, RdRqIn, ALURes, Mem_Write, MemRead,
		ALUOut, WriteRegDataOut, clk, rst, Mem_Addr);

    //input [15:0]PC;
    input flush;
    input [31:0]RdRqIn;
    input [31:0]ALURes;
    input Mem_Write;	//1 = write to memory
    input MemRead;
    input clk, rst;
    input [5:0]Mem_Addr;

    output [31:0]ALUOut;
    output [31:0]WriteRegDataOut;

    wire [31:0]MemDataOut;
    //pass signals through to next stage
    assign ALUOut = ALURes;

    assign WriteRegDataOut = MemRead ? MemDataOut : ALURes;

    //memory stuff here :) use WriteDataIn, ALURes, Mem_Write
    memory2c MEM0(.data_out(MemDataOut), .data_in(RdRqIn[15:0]), .addr(ALURes[15:0]), .enable(1'b1), .wr(Mem_Write), .createdump(1'b0), .clk(clk), .rst(rst));
    //datamem ram1port_32(.address(Mem_Addr),.clock(clk),.data(RdRqIn),.wren(Mem_Write),.q(MemDataOut));



  
endmodule
