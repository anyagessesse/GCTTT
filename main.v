module main(
	input CLOCK_50,
	input [3:0]KEY,
	output [9:0]LEDR);

proc p0(.clk(CLOCK_50), .rst(KEY[0]), .leds(LEDR));

endmodule




