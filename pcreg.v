module pcreg(clk, rst, write_en, pc_in, pc_out);
  
  input clk, rst, write_en;
  input [15:0]pc_in;
  output [15:0]pc_out;
  
 
  reg [15:0]pc_reg;

  //read data
  assign pc_out = pc_reg;
  
  //write data
  always @(posedge clk, posedge rst) begin   
  	if (rst) begin
		pc_reg <= 16'h0000;
	end
	else if (write_en) begin
        	pc_reg <= pc_in;
	end
  end 

endmodule 
