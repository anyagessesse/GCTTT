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
				oDetect
				);

input	[10:0]	iX_Cont;
input	[10:0]	iY_Cont;
input	[11:0]	iDATA;
input			iDVAL;
input			iCLK;
input			iRST;
output	[11:0]	oGrey;
output			oDVAL;
output reg oDetect;
wire	[11:0]	mDATA_0;
wire	[11:0]	mDATA_1;
reg		[11:0]	mDATAd_0;
reg		[11:0]	mDATAd_1;
reg		[13:0]	mCCD_G;
reg				mDVAL;


//assign oGrey = (iX_Cont >= 11'd500 & iX_Cont <= 11'd780 & iY_Cont >= 11'd80 & iY_Cont <= 11'd880) ?  mCCD_G[13:2] : 12'h000;
//assign oGrey = (iX_Cont >= 11'd220 & iX_Cont <= 11'd1025 & iY_Cont >= 11'd70 & iY_Cont <= 11'd860) ? mCCD_G[13:2] : 12'h000;
assign oGrey = (mCCD_G[13:2] < 1000 & iX_Cont >= 11'd220 & iX_Cont <= 11'd1025 & iY_Cont >= 11'd70 & iY_Cont <= 11'd860) ? 12'hFFF : 12'h000;
//assign oGrey = mCCD_G[13:2];
//assign	oGrey	=	(mCCD_G[13:2] < 1000 & iX_Cont >= 11'd500 & iX_Cont <= 11'd780 & iY_Cont >= 11'd80 & iY_Cont <= 11'd880) ? 12'hFFF : 12'h000;

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


