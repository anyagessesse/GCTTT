module ALUForward(WB_RdData_in,MEM_RdData_in,RqRdData,RsData,WB_Rd_in,MEM_Rd_in,RqRd,Rs,PrevWriteEn,PrevPrevWriteEn,PrevMemRead,PrevPrevMemRead,fRqRdData,fRsData);


input [31:0]WB_RdData_in;
input [31:0]MEM_RdData_in;
input [31:0]RqRdData;
input [31:0]RsData;
input [2:0]WB_Rd_in;
input [2:0]MEM_Rd_in;
input [2:0]RqRd;
input [2:0]Rs;
input PrevWriteEn;
input PrevPrevWriteEn;
input PrevMemRead;
input PrevPrevMemRead;


output [31:0]fRqRdData;
output [31:0]fRsData;


wire fwrdA,fwrdB,fwrdC,fwrdD;


assign fwrdA = (WB_Rd_in == RqRd);
assign fwrdB = (WB_Rd_in == Rs);
assign fwrdC = (MEM_Rd_in == RqRd);
assign fwrdD = (MEM_Rd_in == Rs);




assign fRqRdData = fwrdC & PrevWriteEn ? MEM_RdData_in :
		   fwrdA & PrevPrevWriteEn ? WB_RdData_in :
		   RqRdData;

assign fRsData = fwrdD & PrevWriteEn ? MEM_RdData_in :
		 fwrdB & PrevPrevWriteEn ? WB_RdData_in :
		 RsData;


endmodule



