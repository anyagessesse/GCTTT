module NoiseRemove (iCLK,
					iRST,
					iBinary,
					iDVAL,
					iX_Cont, 
					iY_Cont,
					iFrame_En,
					oDCLEAN,
					oDVAL
					);

input	      	iCLK;
input			iRST;
input	    	iBinary;
input	     	iDVAL;
input	[15:0]  iX_Cont;
input	[15:0]  iY_Cont;
input			iFrame_En;
output 	    	oDCLEAN;
output			oDVAL;

//internel Signals
//temporary trying without using filter
assign oDVAL = iDVAL;
assign oDCLEAN = iBinary;

//Step1: Opening
//	1.1: Erosion
//	1.2: Dilation
//Step2: Closing
//	2.1: Dilation
//	2.2: Erosion

endmodule