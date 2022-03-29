module decode(PC, PCPlus2, inst, PCOut, RdRq, Rs, write_en, JumpOrBranchHigh, RqRdOrImm, RsOrImm, ALUCtrl);

      input [?:0]PC, PCPlus2; //pc size?
      input [11:0]inst;  //[15:3] of whole instruction

      output [?:0]PCOut; //pc size?
      output [2:0]RdRq, Rs;  //go to register file
      output write_en;  //pass through stages for write back

      // control signals
      output JumpOrBranchHigh;
      output RqRdOrImm;
      output RsOrImm;
      output ALUCtrl;

      //control unit
      control(inst[15:12], JumpOrBranchHigh, RqRdOrImm, RsOrImm, ALUCtrl);

      // move to control file
      assign JumpOrBranchHigh = 
  
      //pc select, keep same PC if halt is high
      assign PCOut = (inst[15:12] == 3'b0001) ? PC : PCPlus2;

      // select rd or rq register, pass register numbers to rf
      assign RdRq = inst[14] ? inst[11:9] : inst[5:3];
      assign Rs = inst[8:6];

  
endmodule 
  
  
  


