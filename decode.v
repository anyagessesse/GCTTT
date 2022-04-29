module decode(clk, rst, PC, PCPlus1, inst, PCOut, inst_out, BranchHigh, JumpHigh,
		 RqRdOrImm, RsOrImm, ALUCtrl, MemWrite, MemRead, halt,
		 reg1_data, reg2_data, write_reg_out, write_en_out,
		 write_reg_in, write_en_in, write_data,RqRd,Rs,leds, sw, pixel_en,
		 pixel_addr, pixel_value, int_done);

      input [15:0]PC, PCPlus1; 
      input [15:0]inst;  
      input clk, rst;
      input write_en_in;
      input [2:0]write_reg_in;
      input [31:0]write_data;

      output [15:0]PCOut; 
      output [15:0]inst_out;
      output halt;  //goes to write back
      output [9:0]leds;
      input [1:0] sw;
    
      // control signals
      output BranchHigh;
      output JumpHigh;
      output RqRdOrImm;
      output RsOrImm;
      output [3:0]ALUCtrl;
      output MemWrite; //indicates if memory is being written to, goes to mem phase
      output MemRead;  //indicates if memory is being read, goes to mem phase
      output [31:0]reg1_data, reg2_data;
      output [2:0]write_reg_out;
      output write_en_out;
      output [2:0]RqRd, Rs;
      output pixel_en, pixel_value;
      output [31:0]pixel_addr;
      output int_done;

      reg [3:0]ALUIn;
     

      // move to control file
      assign halt = (inst[15:12] == 4'b0000) & !rst;
      assign BranchHigh = inst[15:12] == 4'b0010;  //1 = branch or jump, 0 = no branch or jump
      assign JumpHigh = inst[15:12] == 4'b0100;
      assign RqRdOrImm = (inst[15:12] == 4'b1000) | (inst[15:12] == 4'b0111); //1 = immediate, 0 = RdRq
      assign RsOrImm = inst[14] & inst[15] & ~halt; //1 = use imm, 0 = use Rs
      assign write_en_out = inst[15] | (inst[15:12] == 4'b0110);
      assign MemWrite = inst[15:12] == 4'b0111;
      assign MemRead = inst[15:12] == 4'b1000;
      assign pixel_en = inst[15:12] == 4'b0101;
      assign pixel_value = inst[0];
      assign inst_out = inst;
      assign write_reg_out = inst[11:9];
      assign pixel_addr = reg1_data;
      assign int_done = inst[15:12] == 4'b0011;

      rf RF0(.clk(clk), .rst(rst), .read1_reg(RqRd), .read2_reg(Rs), 
	     .write_reg(write_reg_in), .write_data(write_data), .write_en(write_en_in), 
	     .read1_data(reg1_data), .read2_data(reg2_data), .leds(leds), .sw(sw));

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
      assign RqRd = inst[14] ? inst[11:9] : inst[5:3];
      assign Rs = inst[8:6];

  
endmodule 
  
  
  


