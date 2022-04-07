module fetch(clk, rst,newPC,instr,PC,PCPlus1,halt,jorb);


	input clk;
	input rst;
	input [15:0]newPC; //what is the size of the PC?
	input halt;
	input jorb;
	
	output [15:0]instr;
	output [15:0]PC;
	output [15:0]PCPlus1;

	wire [15:0]nextPC;


	// decide next pc value
	assign nextPC = halt? PC : 
			jorb? newPC:
			PCPlus1;


	// dff to hold PC value
	dff DFF0[15:0](.q(PC), .d(nextPC), .clk(clk), .rst(rst));
	
	// adder to increment the PC (what value to increment by?)
	assign PCPlus1 = PC + 1;
	
	// fetch instruction from memory (how will memory work for instructions?)
	memory2c MEM0(.data_out(instr), .data_in(16'h0000), .addr(PC), .enable(1'b1), .wr(1'b0), .createdump(1'b0), .clk(clk), .rst(rst));


endmodule
