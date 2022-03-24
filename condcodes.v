module condcodes(ALUOut,A,B,EQ,LT,GT,LE,GE,NE);

	input [31:0]ALUOut;
	input [31:0]A;
	input [31:0]B;
	
	output EQ;
	output LT;
	output GT;
	output LE;
	output GE;
	output NE;
	
	wire neg;
	wire zero;
	wire overflow;
	
	// determine neg and zero flags
	
	// determine overflow
	
	// set all condition codes






endmodule
