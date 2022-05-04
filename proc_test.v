module proc_test();

reg ipu_int;
wire [3:0]grid_coord_out;
reg clk, rst;
reg [3:0]grid_coord_in;

wire pixel_en, pixel_value;
wire [31:0]pixel_addr;
wire int_ack;

reg write_en;
reg [3:0]coord_in;

proc PROC0(.clk(clk),.rst(rst),.leds(),.sw(2'b0),.pixel_addr(pixel_addr), 
		.pixel_value(pixel_value),.pixel_en(pixel_en), 
		.ipu_int(ipu_int),.int_ack(int_ack),.grid_coord(grid_coord_in));

grid_coord COORD0(.clk(clk),.rst(rst),.write_en(write_en),.coord_in(coord_in),.coord_out(grid_coord_out));

assign ipu_int = int_ack ? 1'b0 : ipu_int;
assign grid_coord_in = grid_coord_out;

initial begin
	clk = 0;
	rst = 1'b1;
	assign ipu_int = 1'b0;
	@(posedge clk) 
	rst = 1'b0;
	repeat(7) @(posedge clk);
	assign ipu_int = 1'b1;
	assign grid_coord_in = 4'b0010;
	@(posedge clk);
	@(posedge clk);
	assign ipu_int = 1'b0;
	@(posedge clk);
	assign ipu_int = 1'b1;
	@(posedge clk);
	assign ipu_int = 1'b0;
	repeat(40) @(posedge clk);
	$stop;
end
	
	


always 
	#5 clk = ~clk;

endmodule 
