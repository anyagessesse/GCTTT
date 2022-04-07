module decode(clk, rst, PC, PCPlus1, inst, PCOut, inst_out, JumpOrBranchHigh,
		 RqRdOrImm, RsOrImm, ALUCtrl, MemWrite, MemRead, halt,
		 reg1_data, reg2_data, write_reg_out, write_en_out,
		 write_reg_in, write_en_in, write_data);

      input [15:0]PC, PCPlus1; 
      input [15:0]inst;  
      input clk, rst;
      input write_en_in;
      input [2:0]write_reg_in;
      input [31:0]write_data;

      output [15:0]PCOut; 
      output [15:0]inst_out;
      output halt;  //goes to write back
    
      // control signals
      output JumpOrBranchHigh;
      output RqRdOrImm;
      output RsOrImm;
      output [3:0]ALUCtrl;
      output MemWrite; //indicates if memory is being written to, goes to mem phase
      output MemRead;  //indicates if memory is being read, goes to mem phase
      output [31:0]reg1_data, reg2_data;
      output [2:0]write_reg_out;
      output write_en_out;

      reg [3:0]ALUIn;
      wire [2:0]RdRq, Rs;

      // move to control file
      assign halt = (inst[15:12] == 4'b0000) & !rst;
      assign JumpOrBranchHigh = (inst[15:12] == 4'b0100) | (inst[15:12] == 4'b0010);  //1 = branch or jump, 0 = no branch or jump
      assign RqRdOrImm = (inst[15:12] == 4'b1000) | (inst[15:12] == 4'b0111); //1 = immediate, 0 = RdRq
      assign RsOrImm = ~inst[13] & ~halt; //1 = use Rs, 0 = use imm
      assign write_en_out = inst[15];
      assign MemWrite = inst[15:12] == 4'b0111;
      assign MemRead = inst[15:12] == 4'b1000;
      assign inst_out = inst;
      assign write_reg_out = inst[11:9];

      rf RF0(.clk(clk), .rst(rst), .read1_reg(RdRq), .read2_reg(Rs), 
	     .write_reg(write_reg_in), .write_data(write_data), .write_en(write_en_in), 
	     .read1_data(reg1_data), .read2_data(reg2_data));

      always @(*) begin
	case (inst[15:12]) 
		4'b1100: ALUIn <= 4'b0000;
		4'b1101: ALUIn <= 4'b0001;
		4'b1110: ALUIn <= 4'b0010;
		4'b1111: ALUIn <= 4'b0011;
		4'b1011: ALUIn <= (|inst[2:0] ? {1'b0, inst[2:0]} : 4'b1000);
		4'b1010: ALUIn <= {1'b1, inst[2:0]};
		default: ALUIn <= 4'b1111;
	endcase
      end 

      assign ALUCtrl = ALUIn;		
  
      //pc select, keep same PC if halt is high
      assign PCOut = (inst[15:12] == 4'b0000) ? PC : PCPlus1;

      // select rd or rq register, pass register numbers to rf
      assign RdRq = inst[14] ? inst[11:9] : inst[5:3];
      assign Rs = inst[8:6];

  
endmodule 
  
  
  


