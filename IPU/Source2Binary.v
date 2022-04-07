module Source2Binary (iCLK,
					iRST,
					iDATA,
					iDVAL,
					iX_Cont, 
					iY_Cont,
					iFrame_En,
					oBinary,
					oDVAL
					);

input	      	iCLK;
input			iRST;
input	[11:0]	iDATA;
input	     	iDVAL;
input	[15:0]  iX_Cont;
input	[15:0]  iY_Cont;
input			iFrame_En;
output 	    	oBinary;
output			oDVAL;

//Internel Signals 
wire	    [11:0]	oGrey;
wire	[11:0]	mDATA_0;
wire	[11:0]	mDATA_1;
reg		[11:0]	mDATAd_0;
reg		[11:0]	mDATAd_1;
reg		[13:0]	mCCD_G;
reg				mDVAL;
reg				mBinary;

// First Step: Convert the image to be in Gray Scale
assign	oGrey	=	mCCD_G[13:2];
assign	oDVAL	=	mDVAL;

Line_Buffer1 	u0	(	.clken(iDVAL),
						.clock(iCLK),
						.shiftin(iDATA),
						.taps0x(mDATA_1),
						.taps1x(mDATA_0)	);

always@(posedge iCLK or posedge iRST)
begin
	if(iRST)
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

// Second Step: Convert the Gray Scaled image to be in Binary
always @(posedge iCLK, posedge iRST) begin
	if (iRST) mBinary = 1'b0;
	else if (oGrey >= 8'd205 && oGrey <= 8'd255) mBinary = 1'b0; // background color
	else mBinary = 1'b1; // skin color
end

assign oBinary = mBinary;
endmodule