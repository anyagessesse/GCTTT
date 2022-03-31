module IPU (iCLK,
			iRST,
			iFVAL,
			iX_Cont,
			iY_Cont, 
			iDATA,
			iDVAL,
			oGrid_Num,
			oStable_hand
			);
input	      	iCLK;
input			iRST;
input			iFVAL;
input	[15:0]  iX_Cont;
input	[15:0]  iY_Cont;
input	[11:0]	iDATA;
input	     	iDVAL;
output 	[3:0]	oGrid_Num;
output			oStable_hand;

// code starts from here

endmodule