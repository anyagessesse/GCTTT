module FTPositionDetection (iCLK,
                            iRST,
                            iDCLEAN,
                            iDVAL,
                            iX_Cont, 
                            iY_Cont,
                            iFrame_En,
                            oFT_X ,
                            oFT_Y,
                            oDVAL
                            );

input	      	iCLK;
input			iRST;
input	     	iDCLEAN;
input	     	iDVAL;
input	[15:0]  iX_Cont;
input	[15:0]  iY_Cont;
input			iFrame_En;
output 	[9:0]	oFT_X;
output	[9:0]	oFT_Y;
output			oDVAL;

// code starts from here

endmodule