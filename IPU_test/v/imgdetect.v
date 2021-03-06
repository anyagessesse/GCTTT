// --------------------------------------------------------------------
// Copyright (c) 20057 by Terasic Technologies Inc. 
// --------------------------------------------------------------------
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
//
// --------------------------------------------------------------------
//           
//                     Terasic Technologies Inc
//                     356 Fu-Shin E. Rd Sec. 1. JhuBei City,
//                     HsinChu County, Taiwan
//                     302
//
//                     web: http://www.terasic.com/
//                     email: support@terasic.com
//
// --------------------------------------------------------------------
//
// Major Functions:	RAW2RGB
//
// --------------------------------------------------------------------
//
// Revision History :
// --------------------------------------------------------------------
//   Ver  :| Author            :| Mod. Date :| 		Changes Made:
//   V1.0 :| Johnny Fan        :| 07/08/01  :|      Initial Revision
// --------------------------------------------------------------------

module imgdetect(oDVAL,
				iX_Cont,
				iY_Cont,
				iDATA,
				iDVAL,
				iCLK,
				iRST,
				oLoc,
				iFrame,
				oInt,
				oGrey,
				);

input	[10:0]	iX_Cont;
input	[10:0]	iY_Cont;
input	[11:0]	iDATA;
input			iDVAL;
input			iCLK;
input			iRST;
input iFrame;
output oInt;
output reg [3:0] oLoc;
//output [3:0] loc;

output oDVAL;


reg oDetect;

output 	[11:0]  oGrey;
wire	[11:0]	mDATA_0;
wire	[11:0]	mDATA_1;
reg		[11:0]	mDATAd_0;
reg		[11:0]	mDATAd_1;
reg		[13:0]	mCCD_G;
reg				mDVAL;
reg [3:0] curr_loc;
reg [3:0] prev_loc, prev_2loc;

reg internal_int;

wire [3:0] loc_t;
reg [15:0] visited;

localparam [10:0] edge_left = 11'd220;
localparam [10:0] edge_right = 11'd1025;
localparam [10:0] edge_top = 11'd70;
localparam [10:0] edge_bottom = 11'd860;
localparam [10:0] left = 11'd482;
localparam [10:0] right = 11'd760;
localparam [10:0] top = 11'd328;
localparam [10:0] bottom = 11'd604;
 
always @(posedge iCLK or negedge iRST) begin
	if (!iRST) begin
		visited <= 16'h00;
	end
	else if (internal_int & (&iFrame)) begin
		visited[{curr_loc[1:0],curr_loc[3:2]}] <= 1'b1;
	end
end

always @(posedge iCLK or negedge iRST) begin
	if (!iRST) begin
		prev_loc <= 4'hF;
		prev_2loc <= 4'hF;
	end
	else begin
		prev_loc <= curr_loc;
		prev_2loc <= prev_loc;
	end
end

assign interrupt_t = (prev_loc != curr_loc) & (~&curr_loc);
assign oInt = internal_int & (&iFrame);

always @(posedge iCLK or negedge iRST) begin
	if(!iRST) 
		internal_int <= 1'b0;
	else if (&iFrame) 
		internal_int <= 1'b0;
	else if (interrupt_t)
		internal_int <= 1'b1;
end


always @(posedge iCLK or negedge iRST) begin
	if (!iRST) begin
		oLoc <= 4'hF;
	end
	else if (internal_int & (&iFrame)) begin
		oLoc <= {curr_loc[1:0],curr_loc[3:2]};
	end
end


//assign oGrey = (iX_Cont >= 11'd220 & iX_Cont <= 11'd1025 & iY_Cont >= 11'd70 & iY_Cont <= 11'd860) ?  mCCD_G[13:2] : 12'h000;
//assign oGrey = (mCCD_G[13:2] < 1000 & iX_Cont >= edge_left & iX_Cont <= edge_right & iY_Cont >= edge_top & iY_Cont <= edge_bottom) ? mCCD_G[13:2] : 12'h000;


assign oGrey = (iX_Cont >= edge_left & iX_Cont <= edge_right & iY_Cont >= edge_top & iY_Cont <= (11'd80)) ? 12'hFFF : 
			   (iX_Cont >= edge_left & iX_Cont <= edge_right & iY_Cont >= 11'd330 & iY_Cont <= 11'd340) ? 12'hFFF : 
			   (iX_Cont >= edge_left & iX_Cont <= edge_right & iY_Cont >= 11'd590 & iY_Cont <= 11'd600) ? 12'hFFF : 
			   (iX_Cont >= edge_left & iX_Cont <= edge_right & iY_Cont >= 11'd850 & iY_Cont <= 11'd860) ? 12'hFFF :
			   (iX_Cont >= edge_left & iX_Cont <= 11'd230 & iY_Cont >= edge_top & iY_Cont <= edge_bottom) ? 12'hFFF: 
			   (iX_Cont >= 11'd485 & iX_Cont <= 11'd495 & iY_Cont >= edge_top & iY_Cont <= edge_bottom) ? 12'hFFF : 
			   (iX_Cont >= 11'd750 & iX_Cont <= 11'd760 & iY_Cont >= edge_top & iY_Cont <= edge_bottom) ? 12'hFFFF : 
			   (iX_Cont >= 11'd1015 & iX_Cont <= 11'd1025 & iY_Cont >= edge_top & iY_Cont <= edge_bottom) ? 12'hFFF : 
			   (iX_Cont >= (11'd250 + loc_t[3:2] * 11'd265) & iX_Cont <= (11'd465 + loc_t[3:2] * 11'd265) & iY_Cont >= (11'd100 + loc_t[1:0] * 11'd260) & iY_Cont <= (11'd310 + loc_t[1:0] * 11'd260) & 
				(((iX_Cont - loc_t[3:2] * 11'd265) >= (iY_Cont - loc_t[1:0] * 11'd260) + 11'd150) & ((iX_Cont - loc_t[3:2] * 11'd265) <= (iY_Cont - loc_t[1:0] * 11'd260) + 11'd155 ) | ((iX_Cont - loc_t[3:2] * 11'd265) >= (11'd560 - (iY_Cont - loc_t[1:0] * 11'd260)) & (iX_Cont - loc_t[3:2] * 11'd265) <= 11'd565 - (iY_Cont - loc_t[1:0] * 11'd260))) & (~&loc_t) & visited[loc_t]) ? 12'hFFF : 12'h000;

//assign oGrey = mCCD_G[13:2];
//assign oGrey = (mCCD_G[13:2] < 1000 & iX_Cont >= 11'd220 & iX_Cont <= 11'd1025 & iY_Cont >= 11'd70 & iY_Cont <= 11'd860) ? 12'hFFF : 12'h000;
//assign oGrey = mCCD_G[13:2];
//assign	oGrey	=	(mCCD_G[13:2] < 1000 & iX_Cont >= 11'd500 & iX_Cont <= 11'd780 & iY_Cont >= 11'd80 & iY_Cont <= 11'd880) ? 12'hFFF : 12'h000;

//assign loc = curr_loc;

assign loc_t = (iX_Cont >= edge_left & iX_Cont <= left & iY_Cont >= edge_top & iY_Cont <= top) ? 4'b0000 :
			   (iX_Cont >= edge_left & iX_Cont <= left & iY_Cont >= top & iY_Cont <= bottom) ? 4'b0001 :
			   (iX_Cont >= edge_left & iX_Cont <= left & iY_Cont >= bottom & iY_Cont <= edge_bottom) ? 4'b0010 :
			   (iX_Cont >= left & iX_Cont <= right & iY_Cont >= edge_top & iY_Cont <= top) ? 4'b0100 :
			   (iX_Cont >= left & iX_Cont <= right & iY_Cont >= top & iY_Cont <= bottom) ? 4'b0101 :
			   (iX_Cont >= left & iX_Cont <= right & iY_Cont >= bottom & iY_Cont <= edge_bottom) ? 4'b0110 :
			   (iX_Cont >= right & iX_Cont <= edge_right & iY_Cont >= edge_top & iY_Cont <= top) ? 4'b1000 :
			   (iX_Cont >= right & iX_Cont <= edge_right & iY_Cont >= top & iY_Cont <= bottom) ? 4'b1001 :
			   (iX_Cont >= right & iX_Cont <= edge_right & iY_Cont >= bottom & iY_Cont <= edge_bottom) ? 4'b1010 : 4'b1111;

always @(posedge iCLK or negedge iRST) begin
	if (!iRST) begin
		curr_loc <= 4'hF;
	end
	else if (&iFrame) 
		curr_loc <= 4'hF;
	else if (mCCD_G[13:2] < 1000 & iX_Cont >= edge_left & iX_Cont <= left & iY_Cont >= edge_top & iY_Cont <= top) begin
		curr_loc <= 4'b0000;
	end
	else if (mCCD_G[13:2] < 1000 & iX_Cont >= edge_left & iX_Cont <= left & iY_Cont >= top & iY_Cont <= bottom) begin
		if (curr_loc[1:0] > 2'h0)
			curr_loc <= 4'b0100;
	end
	else if (mCCD_G[13:2] < 1000 & iX_Cont >= edge_left & iX_Cont <= left & iY_Cont >= bottom & iY_Cont <= edge_bottom) begin
		if (curr_loc[1:0] > 2'h0) 
			curr_loc <= 4'b1000;
	end
	else if (mCCD_G[13:2] < 1000 & iX_Cont >= left & iX_Cont <= right & iY_Cont >= edge_top & iY_Cont <= top) begin
		if (curr_loc[1:0] > 2'h1) 
			curr_loc <= 4'b0001;
	end
	else if (mCCD_G[13:2] < 1000 & iX_Cont >= left & iX_Cont <= right & iY_Cont >= top & iY_Cont <= bottom) begin
		if (curr_loc[1:0] > 2'h1)
			curr_loc <= 4'b0101;
	end
	else if (mCCD_G[13:2] < 1000 & iX_Cont >= left & iX_Cont <= right & iY_Cont >= bottom & iY_Cont <= edge_bottom) begin
		if (curr_loc[1:0] > 2'h1)
			curr_loc <= 4'b1001;
	end
	else if (mCCD_G[13:2] < 1000 & iX_Cont >= right & iX_Cont <= edge_right & iY_Cont >= edge_top & iY_Cont <= top) begin
		if (curr_loc[1:0] > 2'h2)
			curr_loc <= 4'b0010;
	end
	else if (mCCD_G[13:2] < 1000 & iX_Cont >= right & iX_Cont <= edge_right & iY_Cont >= top & iY_Cont <= bottom) begin
		if (curr_loc[1:0] > 2'h2)
			curr_loc <= 4'b0110;
	end
	else if (mCCD_G[13:2] < 1000 & iX_Cont >= right & iX_Cont <= edge_right & iY_Cont >= bottom & iY_Cont <= edge_bottom) begin
		if (curr_loc[1:0] > 2'h2)
			curr_loc <= 4'b1010;
	end
	else
		curr_loc <= curr_loc;
end

always @(posedge iCLK or negedge iRST) begin
	if(!iRST)
		oDetect <= 1'b0;
	else if (mCCD_G[13:2] < 1000 & iX_Cont >= 11'd500 & iX_Cont <= 11'd780 & iY_Cont >= 11'd70 & iY_Cont <= 11'd875)
		oDetect <= 1'b1;
end
//assign oDetect = mCCD_G[13:2] < 1000 & iX_Cont >= 11'd500 & iX_Cont <= 11'd780;
assign	oDVAL	=	mDVAL;

Line_Buffer1 	u0	(	.clken(iDVAL),
						.clock(iCLK),
						.shiftin(iDATA),
						.taps0x(mDATA_1),
						.taps1x(mDATA_0)	);

always@(posedge iCLK or negedge iRST)
begin
	if(!iRST)
	begin
		mCCD_G	<=	0;
		mDATAd_0<=	0;
		mDATAd_1<=	0;
		mDVAL	<=	0;
	end
	else
	begin
		mDATAd_0	<=	mDATA_0;
		mDATAd_1	<=	mDATA_1;
		mDVAL		<=	{iY_Cont[0]|iX_Cont[0]}	?	1'b0	:	iDVAL;
		mCCD_G <= mDATA_0 + mDATA_1 + mDATAd_0 + mDATAd_1;
	end
end

endmodule


