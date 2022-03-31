module decode(PC, PCPlus1, inst, PCOut, inst_out, RdRq, Rs, write_en, write_reg,
		JumpOrBranchHigh, RqRdOrImm, RsOrImm, ALUCtrl,
		MemWrite, MemRead);

      input [12:0]PC, PCPlus1; 
      input [15:0]inst;  

      output [12:0]PCOut; 
      output [15:0]inst_out;
      output [2:0]RdRq, Rs, write_reg;  //go to register file and wb
      output write_en;  //goes to write back
    
      // control signals
      output JumpOrBranchHigh;
      output RqRdOrImm;
      output RsOrImm;
      output ALUCtrl;
      output MemWrite; //indicates if memory is being written to, goes to mem phase
      output MemRead;  //indicates if memory is being read, goes to mem phase

      wire halt;
      wire [2:0]func_code;
      reg [3:0]ALUIn;

      // move to control file
      assign JumpOrBranchHigh = (inst[15:12] == 4'b0100) | (inst[15:12] == 4'b0010);  //1 = branch or jump, 0 = no branch or jump
      assign RdRqOrImm = (inst[15:12] == 4'b1000) | (inst[15:12] == 4'b0111); //1 = immediate, 0 = RdRq
      assign RsOrImm = inst[13]; //1 = use Rs, 0 = use imm
      assign write_en = inst[15];
      assign MemWrite = inst[15:12] == 4'b0111;
      assign MemRead = inst[15:12] == 4'b1000;
      assign inst_out = inst;
      assign write_reg = inst[11:9];

      always @(*) begin
	case (inst[15:12]) 
		4'b1100: ALUIn <= 4'b0000;
		4'b1101: ALUIn <= 4'b0001;
		4'b1110: ALUIn <= 4'b0010;
		4'b1111: ALUIn <= 4'b0011;
		4'b1011: ALUIn <= (|inst[2:0] ? {1'b0, inst[2:0]} : 4'b1000);
		4'b1010: ALUIn <= {1'b1, inst[2:0]};
	endcase
      end 

      assign ALUCtrl = ALUIn;		
  
      //pc select, keep same PC if halt is high
      assign PCOut = (inst[15:12] == 4'b0000) ? PC : PCPlus1;

      // select rd or rq register, pass register numbers to rf
      assign RdRq = inst[14] ? inst[11:9] : inst[5:3];
      assign Rs = inst[8:6];

  
endmodule 
  
  
  


