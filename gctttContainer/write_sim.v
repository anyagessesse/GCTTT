module write_sim(addr, val, interrupt, clk, rst);

	input interrupt;
	input clk, rst;
	output [18:0] addr;
	output val;
	
	reg [18:0] int_addr;
	reg int_val;
	
	always @(posedge clk, negedge rst) begin
		if(!rst)
			int_addr <= 0;
		else if (interrupt)
			int_addr <= 0;
		else
			int_addr <= int_addr + 1;
	end
	
	always @(posedge clk, negedge rst) begin
		if(!rst)
			int_val <= 0;
		else if (interrupt)
			int_val <= ~int_val;
	end
	
	assign val = int_val;
	assign addr = int_addr;
endmodule
