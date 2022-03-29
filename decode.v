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

      //internal signals
      wire halt, RqOrRq, ReqWrite;
      wire [2:0]rea1_reg, read2_reg;
  

      //assign internal signals
      assign halt = (inst[15:12] == 4'b0001);
      assign RdOrRq = inst[14];  //1 = Rd, 0 = Rq   **switch opcode for shift and branch?
      assign writeReg = inst[15];  //1 = write to register, 0 = doesn't write to register

      //pc select, keep same PC if halt is high
      assign PCOut = halt ? PC : PCPlus2;
  
      // choose Rd or Rq;
      assign read1_reg = RdOrRq ? inst[11:9] : inst[5:3];
      assign read2_reg = inst[8:6];

      //read or write registers
      registers(read1_reg, read2_reg, write_reg, WriteReg, read1_data, read2_data);

      
      
      
  
      //control unit
      control(inst[15:12], JumpOrBranchHigh, RqRdOrImm, RsOrImm, ALUCtrl);
  
      //pc select, keep same PC if halt is high
      assign PCOut = halt ? PC : PCPlus2;

  
endmodule 
  
  
  


