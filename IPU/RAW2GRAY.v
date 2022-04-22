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

module RAW2GRAY(oGrey,
				oDVAL,
				iX_Cont,
				iY_Cont,
				iDATA,
				iDVAL,
				iCLK,
				iRST,
				oDetect,
				loc,
				iFrame,
				);

input	[10:0]	iX_Cont;
input	[10:0]	iY_Cont;
input	[11:0]	iDATA;
input			iDVAL;
input			iCLK;
input			iRST;
input [1:0]iFrame;
output	[11:0]	oGrey;
output			oDVAL;
output reg oDetect;
output reg [3:0] loc;
wire	[11:0]	mDATA_0;
wire	[11:0]	mDATA_1;
reg		[11:0]	mDATAd_0;
reg		[11:0]	mDATAd_1;
reg		[13:0]	mCCD_G;
reg				mDVAL;
reg [3:0] curr_loc;
reg [3:0] prev_loc, prev_2loc;
wire interrupt;
reg internal_int;

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
		prev_loc <= 4'hF;
		prev_2loc <= 4'hF;
	end
	else begin
		prev_loc <= curr_loc;
		prev_2loc <= prev_loc;
	end
end

assign interrupt = (prev_loc != curr_loc) & (~&curr_loc);

always @(posedge iCLK or negedge iRST) begin
	if(!iRST) 
		internal_int <= 1'b0;
	else if (&iFrame) 
		internal_int <= 1'b0;
	else if (interrupt)
		internal_int <= 1'b1;
end
		
always @(posedge iCLK or negedge iRST) begin
	if (!iRST) begin
		loc <= 4'hF;
	end
	else if (internal_int & (&iFrame)) begin
		loc <= curr_loc;
	end
end


//assign oGrey = (iX_Cont >= 11'd220 & iX_Cont <= 11'd1025 & iY_Cont >= 11'd70 & iY_Cont <= 11'd860) ?  mCCD_G[13:2] : 12'h000;
assign oGrey = (iX_Cont >= edge_left & iX_Cont <= edge_right & iY_Cont >= edge_top & iY_Cont <= edge_bottom) ? mCCD_G[13:2] : 12'h000;
//assign oGrey = (mCCD_G[13:2] < 1000 & iX_Cont >= 11'd220 & iX_Cont <= 11'd1025 & iY_Cont >= 11'd70 & iY_Cont <= 11'd860) ? 12'hFFF : 12'h000;
//assign oGrey = mCCD_G[13:2];
//assign	oGrey	=	(mCCD_G[13:2] < 1000 & iX_Cont >= 11'd500 & iX_Cont <= 11'd780 & iY_Cont >= 11'd80 & iY_Cont <= 11'd880) ? 12'hFFF : 12'h000;

//assign loc = curr_loc;

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


