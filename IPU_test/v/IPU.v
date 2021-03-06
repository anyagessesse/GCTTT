module IPU (
	// General
	input				D5M_PIXLCLK,
	input				CLOCK2_50,
	input				DLY_RST_1,
	input 				DLY_RST_2,
	
	// CCD_Capture
	input [11:0] 		rccd_DATA,
	input 				rccd_FVAL,
	input 				rccd_LVAL,
	input 				iSTART,
	input 				iEND,
	output [15:0]		X_Cont,
	output [15:0]		Y_Cont,
	output [31:0]		Frame_Cont,
	
	// imgdetect
	output [3:0]		loc,
	output				interrupt,
	output				dccd_DVAL,
	output [11:0]		dccd_G,
	
	// I2C
	output				D5M_SCLK,
	inout				D5M_SDATA
);

// CCD_Capture - imgdetect interface
wire [11:0]		mccd_DATA;
wire			mccd_DVAL;


CCD_Capture			camera(.oDATA(mccd_DATA),
						   .oDVAL(mccd_DVAL),
						   .oX_Cont(X_Cont),
						   .oY_Cont(Y_Cont),
						   .oFrame_Cont(Frame_Cont),
						   .iDATA(rccd_DATA),
						   .iFVAL(rccd_FVAL),
						   .iLVAL(rccd_LVAL),
						   .iSTART(iSTART),
						   .iEND(iEND),
						   .iCLK(~D5M_PIXLCLK),
						   .iRST(DLY_RST_2),
						   );
						   
imgdetect			imgproc(.iCLK(D5M_PIXLCLK),
							.iRST(DLY_RST_1),
							.iDATA(mccd_DATA),
							.iDVAL(mccd_DVAL),
							.iX_Cont(X_Cont),
							.iY_Cont(Y_Cont),
							.iFrame(Frame_Cont),
							.oLoc(loc),
							.oInt(interrupt),
							.oDVAL(dccd_DVAL),
							.oGrey(dccd_G),
							);

I2C_CCD_Config		i2c_set	(.iCLK(CLOCK2_50),
							 .iRST_N(DLY_RST_2),
							 .iEXPOSURE_ADJ(1'b1),
							 .iEXPOSURE_DEC_p(1'b0),
							 .iZOOM_MODE_SW(1'b0),
							 // I2C Side
							 .I2C_SCLK(D5M_SCLK),
							 .I2C_SDAT(D5M_SDATA)
							 );

endmodule