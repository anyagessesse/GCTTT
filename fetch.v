module fetch(newPC,instr,PC,PCPlus2);


	input clk;
	input rst;
	input [?:0]newPC; //what is the size of the PC?
	
	output [15:0]instr;
	output [?:0]PC;
	output [?:0]PCPlus2;



	// dff to hold PC value
	
	// adder to increment the PC (what value to increment by?)
	
	// fetch instruction from memory (how will memory work for instructions?)


endmodule
