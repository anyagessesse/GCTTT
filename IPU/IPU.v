module IPU (iCLK,
			iRST,
			iFVAL,
			iX_Cont,
			iY_Cont, 
			iDATA,
			iDVAL,
			oGrid_Num,
			oStable_hand,
			oDATA);
input	      	iCLK;
input			iRST;
input			iFVAL;
input	[15:0]  iX_Cont;
input	[15:0]  iY_Cont;
input	[11:0]	iDATA;
input	     	iDVAL;
output 	[3:0]	oGrid_Num;
output			oStable_hand;
output  [11:0]  oDATA;

wire Frame_En;
wire Binary;
wire DVAL_S2B, DVAL_FTPD;
wire [9:0] iFT_X;
wire [9:0] iFT_Y;
// code starts from here
FrameCapture(.iCLK(iCLK),
				.iRST(iRST),
				.iFVAL(iFVAL),
				.oFrame_En(Frame_En)
				);
Source2Binary(.iCLK(iCLK),
				.iRST(iRST),
				.iDATA(iDATA),
				.iDVAL(iDVAL),
				.iX_Cont(iX_Cont), 
				.iY_Cont(iY_Cont),
				.iFrame_En(Frame_En),
				.oBinary(Binary),
				.oDVAL(DVAL_S2B)
				);
FTPositionDetection (.iCLK(iCLK),
                        .iRST(iRST),
                        .iDCLEAN (Binary),
                        .iDVAL (DVAL_S2B),
                        .iX_Cont (iX_Cont), 
                        .iY_Cont (iY_Cont),
                        .iFrame_En (Frame_En),
                        .oFT_X (iFT_X),
                        .oFT_Y (iFT_Y),
                        .oDVAL (DVAL_FTPD)
                        );
MovementDetection(.iCLK(iCLK),
					.iRST (iRST),
					.iDVAL (DVAL_FTPD),
					.iFT_X (iFT_X),
					.iFT_Y (iFT_Y), 
					.iFrame_En (Frame_En),
					.oGrid_Num (oGrid_Num),
					.oStable_hand (oStable_hand)
					);

assign oDATA = Binary ? 0 : 12'hfff;
endmodule