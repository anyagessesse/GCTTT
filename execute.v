module execute(PCIn,RqRd,Rs,instr,JumpOrBrachHigh,RqRdOrImm,RsOrImm,ALUCtrl,PCOut,flush,RqRd,ALUOut);

	input [12:0]PCIn;
	input [31:0]RqRd; // first read data from registers
	input [31:0]Rs;   // second read data from registers
	input [15:0]instr;
	
	// control signals
	input JumpOrBranchHigh;
	input RqRdOrImm;
	input RsOrImm;
	input ALUCtrl;
	

	output [12:0]PCOut;  //PC after branch logic
	output flush;   //if we need to branch and flush previous steps
	output [31:0]ALUOut;
	
	
	// mux between ALU inputs
	
	// ALU instantiation
	
	// condition codes
	
	// branching logic
	
	// mux for new PC value if branching
	
	
	// forwarding unit (in the future)
	



endmodule
