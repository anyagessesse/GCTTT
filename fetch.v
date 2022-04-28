module fetch(clk, rst,newPC,instr,PC,PCPlus1,halt,jorb,haltPC,ldStallPC,ldStall);


	input clk;
	input rst;
	input [15:0]newPC, haltPC, ldStallPC; //what is the size of the PC?
	input halt;
	input jorb;
        input ldStall;


	output [15:0]instr;
	output [15:0]PC;
	output [15:0]PCPlus1;

	wire [15:0]nextPC;


	// decide next pc value
        assign nextPC = halt ? haltPC :
			jorb ? newPC :
			ldStall ? PC :
			PCPlus1;


	// dff to hold PC value
	dflop DFF0[15:0](.q(PC), .d(nextPC), .clk(clk), .rst(rst));
	
	// adder to increment the PC (what value to increment by?)
	assign PCPlus1 = PC + 1;
	
	//ram1port MEM0(.address(PC),.clock(clk),.data(16'h0000),.wren(1'b0),.q(instr));
	// fetch instruction from memory (how will memory work for instructions?)
	memory2c MEM0(.data_out(instr), .data_in(16'h0000), .addr(PC), .enable(1'b1), .wr(1'b0), .createdump(1'b0), .clk(clk), .rst(rst));


endmodule
