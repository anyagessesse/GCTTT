module IPU(

      ///////// CLOCK2 /////////
      input              CLOCK2_50,

      ///////// SW /////////
      input       [9:0]  SW,

		
		//////////// GPIO1, GPIO1 connect to D5M - 5M Pixel Camera //////////
	   input		   [11:0] D5M_D,
      input		          D5M_FVAL,
      input		          D5M_LVAL,
      input		          D5M_PIXLCLK,
      output		       D5M_SCLK, // I2C output1
      inout		          D5M_SDATA, // I2C output2
      input		          D5M_STROBE,
	  output			[3:0] loc, // grid number --- key output
	  output 			oInterrupt // finger detect interrupt --- key output
	  
);


//=======================================================
//  REG/WIRE declarations
//=======================================================
wire			 [11:0]			mCCD_DATA;
wire								mCCD_DVAL;
wire	       [15:0]			X_Cont;
wire	       [15:0]			Y_Cont;
wire	       [31:0]			Frame_Cont;
wire								DLY_RST_0;
wire								DLY_RST_1;
wire								DLY_RST_2;
wire								DLY_RST_3;
wire								DLY_RST_4;

reg		    [11:0]			rCCD_DATA;
reg								rCCD_LVAL;
reg								rCCD_FVAL;



//power on start
wire             				auto_start;
//=======================================================
//  Structural coding
//=======================================================

//D5M read 
always@(posedge D5M_PIXLCLK)
begin
	rCCD_DATA	<=	D5M_D;
	rCCD_LVAL	<=	D5M_LVAL;
	rCCD_FVAL	<=	D5M_FVAL;
end


//auto start when power on
assign auto_start = ((KEY[0])&&(DLY_RST_3)&&(!DLY_RST_4))? 1'b1:1'b0;
//Reset module

Reset_Delay			ipu1	(	
							.iCLK(CLOCK_50),
							.iRST(KEY[0]),
							.oRST_0(DLY_RST_0),
							.oRST_1(DLY_RST_1),
							.oRST_2(DLY_RST_2),
							.oRST_3(DLY_RST_3),
							.oRST_4(DLY_RST_4)
						   );
//D5M image capture
CCD_Capture			ipu2	(	
							.oDATA(mCCD_DATA),
							.oDVAL(mCCD_DVAL),
							.oX_Cont(X_Cont),
							.oY_Cont(Y_Cont),
							.oFrame_Cont(Frame_Cont),
							.iDATA(rCCD_DATA),
							.iFVAL(rCCD_FVAL),
							.iLVAL(rCCD_LVAL),
							.iSTART(!KEY[3]|auto_start),
							.iEND(!KEY[2]),
							.iCLK(~D5M_PIXLCLK),
							.iRST(DLY_RST_2)
						   );
//D5M raw date convert to RGB data
						   
imageProc			ipu3	(	
							.iCLK(D5M_PIXLCLK),
							.iRST(DLY_RST_1),
							.iDATA(mCCD_DATA),
							.iDVAL(mCCD_DVAL),
							.iX_Cont(X_Cont),
							.iY_Cont(Y_Cont),
							.oInterrupt(oInterrupt),
							.loc(loc),
							.iFrame(Frame_Cont),
						   );
						   
			
I2C_CCD_Config 	ipu4	(	//	Host Side
							.iCLK(CLOCK2_50),
							.iRST_N(DLY_RST_2),
							.iEXPOSURE_ADJ(KEY[1]),
							.iEXPOSURE_DEC_p(SW[0]),
							.iZOOM_MODE_SW(SW[9]),
							//	I2C Side
							.I2C_SCLK(D5M_SCLK),
							.I2C_SDAT(D5M_SDATA)
						   );
endmodule						   