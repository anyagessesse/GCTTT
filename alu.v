module alu(A, B, ALUCtrl, Out);

	input [31:0]A;
	input [31:0]B;
	input [3:0]ALUCtrl;  // operation being executed
	
	output [31:0]Out;
	
	wire [31:0]mv0,mv1,mv2,mv3;
	wire [31:0]shra,shrl,ror,shl,rol;
	wire [31:0]notOut,xorOut,orOut,andOut;
	wire [31:0]subOut,addOut;
	
	
	// move instructions
	assign mv3 = {B[7:0],A[23:0]};
	assign mv2 = {A[31:24],B[7:0],A[15:0]};
	assign mv1 = {A[31:16],B[7:0],A[7:0]};
	assign mv0 = {A[31:8],B[7:0]};
	
	
	// shifts
	assign shra = B >>> A[4:0];
	assign shrl = B >> A[4:0];
	assign shl = B << A[4:0];
	
	// rotates
	assign ror = {B,B} >> A[4:0];
	assign rol = {B,B} << A[4:0];
	
	
	// simple bit operations
	assign notOut = ~B;
	assign xorOut = A ^ B;
	assign orOut = A | B;
	assign andOut = A & B;
	
	
	// add and subtract
	assign subOut = B - A;
	assign addOut = A + B;
	
	
	// mux between all values
	assign Out = (ALUCtrl == 4'b0000) ? mv0 :
			(ALUCtrl == 4'b0001) ? mv1 :
			(ALUCtrl == 4'b0010) ? mv2 :
			(ALUCtrl == 4'b0011) ? mv3 :
			(ALUCtrl == 4'b0111) ? shra :
			(ALUCtrl == 4'b0101) ? shrl :
			(ALUCtrl == 4'b0110) ? ror :
			(ALUCtrl == 4'b0111) ? shl :
			(ALUCtrl == 4'b1000) ? rol :
			(ALUCtrl == 4'b1001) ? notOut :
			(ALUCtrl == 4'b1010) ? xorOut :
			(ALUCtrl == 4'b1011) ? orOut :
			(ALUCtrl == 4'b1100) ? andOut :
			(ALUCtrl == 4'b1101) ? subOut :
			(ALUCtrl == 4'b1110) ? addOut : B;
	
	
	
endmodule
