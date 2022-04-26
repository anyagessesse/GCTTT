module execute(PCIn,RqRd,Rs,instr,JumpHigh,BranchHigh,RqRdOrImm,RsOrImm,ALUCtrl,PCOut,flush,ALUOut,SelectJOrB);

	input [15:0]PCIn;
	input [31:0]RqRd; // first read data from registers
	input [31:0]Rs;   // second read data from registers
	input [15:0]instr;
	
	// control signals
	input JumpHigh;
	input BranchHigh;
	input RqRdOrImm;
	input RsOrImm;
	input [3:0]ALUCtrl;
	

	output [15:0]PCOut;  //PC after branch logic
	output flush;   //if we need to branch and flush previous steps
	output [31:0]ALUOut;
	output SelectJOrB;
	
	wire [31:0]A,B;
	wire EQ,LT,GT,LE,GE,NE;
	wire [31:0]ALUOutTemp;
	
	
	
	// mux between ALU inputs
	assign A = RqRdOrImm ? instr[5:0] : RqRd;
	assign B = RsOrImm ? instr[7:0] : Rs;
	
	
	// ALU instantiation
	alu ALU0(.A(A), .B(B), .ALUCtrl(ALUCtrl), .Out(ALUOutTemp));

	assign ALUOut = (instr[15:12] == 4'b0110) & (instr[2:0] == 3'b001) ? {B[15:0],A[15:0]} :
			(instr[15:12] == 4'b0110) & (instr[2:0] == 3'b000) ? {A[31:16],B[15:0]} :
			ALUOutTemp;
	
	// condition codes
	condcodes CC0(.B(B),.EQ(EQ),.LT(LT),.GT(GT),.LE(LE),.GE(GE),.NE(NE));
	
	
	// branching logic
	jumpbranch JB0(.EQ(EQ),.LT(LT),.GT(GT),.LE(LE),.GE(GE),.NE(NE),.JumpHigh(JumpHigh),.BranchHigh(BranchHigh),.instr(instr),.SelectJOrB(SelectJOrB),.flush(flush));
	
	// mux for new PC value if branching
	assign PCOut = SelectJOrB ? RqRd : PCIn;
	
	// forwarding unit (in the future)
	

endmodule
