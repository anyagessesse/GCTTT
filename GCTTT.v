module GCTTT(
	input CLOCK_50,
	input [3:0]KEY,
	output [9:0]LEDR
      	input  [9:0]SW,
	input  [11:0] D5M_D,
      	input	D5M_FVAL,
      	input	D5M_LVAL,
      	input	D5M_PIXLCLK,
      	output	D5M_SCLK, // I2C output1
      	inout	D5M_SDATA, // I2C output2
      	input	D5M_STROBE);


wire [3:0]loc,grid_loc_out;
wire oInt,int_ack;
wire pixel_en;
wire [31:0]pixel_addr;
wire pixel_value;

//need to connect int_ack to IPU, pixel_addr, pixel_value, and pixel_en to buffer

proc	PROC0(.clk(CLOCK_50),.rst(KEY[0]),.leds(LEDR),.pixel_addr(pixel_addr),.pixel_value(pixel_value),.pixel_en(pixel_en),.ipu_int(oInt),.int_ack(int_act),.grid_coord(grid_loc_out));

IPU	IPU0(.CLOCK2_50(CLOCK_50),.SW(SW),.D5M_D(D5M_D),.D5M_FVAL(D5M_FVAL),.D5M_LVAL(D5M_LVAL),
     		.D5M_PIXLCLK(D5M_PIXLCLK),.D5M_SCLK(D5M_SCLK),.D5M_SDATA(D5M_SDATA), 
      		.D5M_STROBE(D5M_STROBE),.loc(loc),.oInterrupt(oInt));

grid_coord	GRID0(.clk(CLOCK_50),.rst(KEY[0]),.write_en(oInt),.coord_in(loc),.coord_out(grid_loc_out));

endmodule




