
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module IPU_Test(

	//////////// CLOCK //////////
	input 		          		CLOCK2_50,
	input 		          		CLOCK3_50,
	input 		          		CLOCK4_50,
	input 		          		CLOCK_50,

	//////////// KEY //////////
	input 		     [3:0]		KEY,

	//////////// LED //////////
	output		     [9:0]		LEDR,

	//////////// SW //////////
	input 		     [9:0]		SW,

	//////////// GPIO_1, GPIO_1 connect to D5M - 5M Pixel Camera //////////
	input 		    [11:0]		D5M_D,
	input 		          		D5M_FVAL,
	input 		          		D5M_LVAL,
	input 		          		D5M_PIXCLK,
	output		          		D5M_RESET_N,
	output		          		D5M_SCLK,
	inout 		          		D5M_SDATA,
	input 		          		D5M_STROBE,
	output		          		D5M_TRIGGER,
	output		          		D5M_XCLKIN
);



//=======================================================
//  REG/WIRE declarations
//=======================================================
wire				DLY_RST_0;
wire				DLY_RST_1;
wire				DLY_RST_2;
wire				DLY_RST_3;
wire				DLY_RST_4;

reg [11:0]			rccd_DATA;
reg					rccd_LVAL;
reg					rccd_FVAL;

wire [15:0]			X_Cont;
wire [15:0]			Y_Cont;
wire [31:0]			Frame_Cont;

wire start;

wire [3:0]			loc;
wire 				interrupt;
wire				dccd_DVAL;
reg				cpu_int;
reg				prev_int;

//=======================================================
//  Structural coding
//=======================================================

// D5M
assign D5M_TRIGER = 1'b1;
assign D5M_RESET_N = DLY_RST_1;

assign LEDR = {cpu_int, 5'h00, loc};

// auto start when power on
assign start = ((KEY[0]) && (DLY_RST_3) && (!DLY_RST_4)) | !KEY[3];

// D5M read
always @(posedge D5M_PIXCLK) begin
	rccd_DATA <= D5M_D;
	rccd_FVAL <= D5M_FVAL;
	rccd_LVAL <= D5M_LVAL;
end

Reset_Delay		reset(.iCLK(CLOCK_50),
				      .iRST(KEY[0]),
					  .oRST_0(DLY_RST_0),
					  .oRST_1(DLY_RST_1),
					  .oRST_2(DLY_RST_2),
					  .oRST_3(DLY_RST_3),
					  .oRST_4(DLY_RST_4)
					  );

always @(posedge D5M_PIXCLK) begin
	if (!KEY[0])
		cpu_int <= 1'b0;
	else if (!KEY[2])
		cpu_int <= 1'b0;
	else if (interrupt & ~prev_int)
		cpu_int <= 1'b1;
end

always @(posedge D5M_PIXCLK) begin
	if (!KEY[0])
		prev_int <= 1'b0;
	else
		prev_int <= interrupt;
end

IPU				ipu(.D5M_PIXLCLK(D5M_PIXCLK),
					.CLOCK2_50(CLOCK2_50),
					.DLY_RST_1(DLY_RST_1),
					.DLY_RST_2(DLY_RST_2),
					
					// CCD_Capture
					.rccd_DATA(rccd_DATA),
					.rccd_FVAL(rccd_FVAL),
					.rccd_LVAL(rccd_LVAL),
					.iSTART(start),
					.iEND(!KEY[2]),
					.X_Cont(X_Cont),
					.Y_Cont(Y_Cont),
					.Frame_Cont(Frame_Cont),
					
					// imgdetect
					.loc(loc),
					.interrupt(interrupt),
					.dccd_DVAL(dccd_DVAL),
					
					// I2C
					.D5M_SCLK(D5M_SCLK),
					.D5M_SDATA(D5M_SDATA)
					);

sdram_pll		clock(.refclk(CLOCK_50),
					  .rst(1'b0),
					  .outclk_0(sdram_ctrl_clk),
					  .outclk_1(DRAM_CLK),
					  .outclk_2(D5M_XCLKIN),
					  .outclk_3(VGA_CLK),
					  );

endmodule