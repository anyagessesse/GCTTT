module memory(flush, RdRqIn, ALURes, Mem_Write, MemRead,
		ALUOut, WriteRegDataOut, clk, rst);

    //input [15:0]PC;
    input flush;
    input [31:0]RdRqIn;
    input [31:0]ALURes;
    input Mem_Write;	//1 = write to memory
    input MemRead;
    input clk, rst;

    output [31:0]ALUOut;
    output [31:0]WriteRegDataOut;


    wire [15:0]data_imm;
    wire [31:0]MemDataOut;
    //pass signals through to next stage
    assign ALUOut = ALURes;
    assign MemDataOut = {16'h0000, data_imm};

    assign WriteRegDataOut = MemRead ? MemDataOut : ALURes;


    RAM0 Sdram_Control (
		//	HOST Side
    	RESET_N,
	CLK,
		//	FIFO Write Side 1
    	WR1_DATA,
		WR1,
		WR1_ADDR,
		WR1_MAX_ADDR,
		WR1_LENGTH,
		WR1_LOAD,
		WR1_CLK,
		//	FIFO Write Side 2
    	WR2_DATA,
		WR2,
		WR2_ADDR,
		WR2_MAX_ADDR,
		WR2_LENGTH,
		WR2_LOAD,
		WR2_CLK,
		//	FIFO Read Side 1
    	RD1_DATA,
		RD1,
		RD1_ADDR,
		RD1_MAX_ADDR,
		RD1_LENGTH,
		RD1_LOAD,	
		RD1_CLK,
		//	FIFO Read Side 2
    	RD2_DATA,
		RD2,
		RD2_ADDR,
		RD2_MAX_ADDR,
		RD2_LENGTH,
		RD2_LOAD,
		RD2_CLK,
		//	SDRAM Side
    	SA,
    	BA,
    	CS_N,
   	CKE,
    	RAS_N,
    	CAS_N,
    	WE_N,
    	DQ,
    	DQM
	);
    //memory stuff here :) use WriteDataIn, ALURes, Mem_Write
    //memory2c MEM0(.data_out(data_imm), .data_in(RdRqIn[15:0]), .addr(ALURes[15:0]), .enable(1'b1), .wr(Mem_Write), .createdump(1'b0), .clk(clk), .rst(rst));

  
endmodule
