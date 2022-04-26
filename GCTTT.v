module GCTTT(
	input CLOCK_50,
	input [3:0]KEY,
	output [9:0]LEDR);



//assign LEDR = 10'b1111111111;
//reg [27:0]count;

assign LEDR = CLOCK_50 ? 10'b1111111111: 10'b0000000000;


//always @(posedge CLOCK_50)begin
//	count = count + 1;


//	if(KEY[0])
//		LEDR = 10'b0000000000;

//	else if(count == 50000000)
//		LEDR = LEDR + 1;

//end



//proc p0(.clk(CLOCK_50), .rst(KEY[0]), .leds(LEDR));

endmodule




