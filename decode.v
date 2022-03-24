module decode(PC, PCPlus2, inst, PCIn, RqRd, Rs, JumpOrBranchHigh, RqRdOrImm, RsOrImm, ALUCtrl);

      input [?:0]PC, PCPlus2; //pc size?
      input [11:0]inst;  //[15:3] of whole instruction

	output [?:0]PCOut; //pc size?
      output [31:0]RqRd, Rs;

	    // control signals
      output JumpOrBranchHigh;
      output RqRdOrImm;
      output RsOrImm;
      output ALUCtrl;
  
  
      //seperate instructions
  
      //choose rq or rd
  
      //read/write registers
  
      //control unit
      control(inst[15:12], JumpOrBranchHigh, RqRdOrImm, RsOrImm, ALUCtrl);
  
      //pc select
  
endmodule 
  
  
  


