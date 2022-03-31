module fetch(newPC,instr,PC,PCPlus1);


	input clk;
	input rst;
	input [12:0]newPC; //what is the size of the PC?
	
	output [15:0]instr;
	output [12:0]PC;
	output [12:0]PCPlus1;



	// dff to hold PC value
	dff DFF0(.q(PC), .d(newPC), .clk(clk), .rst(rst));
	
	// adder to increment the PC (what value to increment by?)
	assign PCPlus1 = PC + 1;
	
	// fetch instruction from memory (how will memory work for instructions?)
	memory2c MEM0(.data_out(instr), .data_in(16'h0000), .addr(PC), .enable(1'b1), .wr(1'b0), .createdump(1'b0), .clk(clk), .rst(rst));


endmodule
