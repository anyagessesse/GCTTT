module registers(read1_reg, read2_reg, write_reg, write_data, write_en, read1_data, read2_data);
  
  input [2:0]read1_reg, read2_reg, write_reg;
  input [31:0]write_data;
  input write_en;
  
  output [31:0]read1_data, read2_data;
  
 
  // registers
  reg [31:0] reg0, reg1, reg2, reg3, reg4, reg5, reg6, special;

  // read data
  assign read1_data = read1_reg = 3'b000 ? reg0 :
		      read1_reg = 3'b001 ? reg1 :
		      read1_reg = 3'b010 ? reg2 :
                      read1_reg = 3'b011 ? reg3 :
                      read1_reg = 3'b100 ? reg4 :
                      read1_reg = 3'b101 ? reg5 :
                      read1_reg = 3'b110 ? reg6 : special;

  assign read2_data = read2_reg = 3'b000 ? reg0 :
		      read2_reg = 3'b001 ? reg1 :
		      read2_reg = 3'b010 ? reg2 :
                      read2_reg = 3'b011 ? reg3 :
                      read2_reg = 3'b100 ? reg4 :
                      read2_reg = 3'b101 ? reg5 :
                      read2_reg = 3'b110 ? reg6 : special;
  

  //write data
  always @(posedge clk) begin   
	if (write_en) begin
        	case (write_reg) begin
			3'b000: reg0 <= write_data;
			3'b001: reg1 <= write_data;
			3'b010: reg2 <= write_data;
			3'b011: reg3 <= write_data;
			3'b100: reg4 <= write_data;
			3'b101: reg5 <= write_data;
			3'b110: reg6 <= write_data;
			default: special <= write_data;
		endcase
	end
  end 

endmodule 
