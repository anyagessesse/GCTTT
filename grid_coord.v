module grid_coord(clk, rst, write_en, coord_in, coord_out);
  
  input clk, rst, write_en;
  input [3:0]coord_in;
  output [3:0]coord_out;
  
 
  reg [3:0]grid_coord;

  //read data
  assign coord_out = grid_coord;
  
  //write data
  always @(posedge clk, posedge rst) begin   
  	if (rst) begin
		grid_coord <= 4'h0;
	end
	else if (write_en) begin
        	grid_coord <= coord_in;
	end
  end 

endmodule 
