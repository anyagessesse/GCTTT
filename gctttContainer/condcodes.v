module condcodes(B,EQ,LT,GT,LE,GE,NE);

	input [31:0]B;
	
	output EQ;
	output LT;
	output GT;
	output LE;
	output GE;
	output NE;
	
	wire neg;
	wire zero;
	
	// comparing B to zero
	
	// determine neg and zero flags
	assign neg = B[31];
	assign zero = ~|B;
	
	
	// set all condition codes
	assign EQ = zero;
	assign LT = ~zero & neg;
	assign GT = ~zero & ~neg;
	assign LE = zero | neg;
	assign GE = zero | ~neg;
	assign NE = ~zero;


endmodule
