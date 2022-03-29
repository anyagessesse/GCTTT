module condcodes(ALUCtrl,ALUOut,A,B,EQ,LT,GT,LE,GE,NE);

	input [3:0]ALUCtrl;
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
	wire adding;
	wire subtracting;
	wire overflow1,overflow2;
	
	// determine neg and zero flags
	assign neg = ALUOut[31];
	assign zero = ~|ALUOut;
	
	// determine overflow
	assign adding = (ALUCtrl == 4'b1110) ? 1'b1 : 1'b0;
	assign subtracting = (ALUCtrl == 4'b1101) ? 1'b1 : 1'b0;
	
	assign overflow1 = (ALUOut[31] & ~A[31] & ~B[31]) | (~ALUOut[31] & A[31] & B[31]);
	assign overflow2 = (ALUOut[31] & A[31] & ~B[31]) | (~ALUOut[31] & ~A[31] & B[31]);
	
	assign overflow = (adding & overflow1) | (subtracting & overflow2);
	
	// set all condition codes
	assign EQ = ~overflow & zero;
	assign LT = ~overflow & ~zero & neg;
	assign GT = ~overflow & ~zero & ~neg;
	assign LE = ~overflow & (zero | neg);
	assign GE = ~overflow & (zero | ~neg);
	assign NE = ~overflow & ~zero;


endmodule
