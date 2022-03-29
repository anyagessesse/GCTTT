module jumpbranch(EQ,LT,GT,LE,GE,NE,JumpOrBranchHigh,instr,SelectJOrB,flush);

	input EQ;
	input LT;
	input GT;
	input LE;
	input GE;
	input NE;
	input JumpOrBranchHigh;
	input instr;
	
	output SelectJOrB;
	output flush;
	
	wire w1,w2,w3,w4,w5,w6;
	
	// decide if we should branch based on opcode & condition codes
	
	assign w1 = (instr[2:0] == 3'b000) & LT;
	assign w2 = (instr[2:0] == 3'b001) & GT;
	assign w3 = (instr[2:0] == 3'b010) & LE;
	assign w4 = (instr[2:0] == 3'b011) & GE;
	assign w5 = (instr[2:0] == 3'b100) & EQ;
	assign w6 = (instr[2:0] == 3'b101) & NE;
	
	assign SelectJOrB = JumpOrBranchHigh & (w1 | w2 | w3 | w4 | w5 | w6);
	assign flush = SelectJOrB;


endmodule

