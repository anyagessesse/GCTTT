module FrameCapture (iCLK,
					iRST,
					iFVAL,
					oFrame_En,
					);

input	      	iCLK;
input			iRST;
input			iFVAL;
output			oFrame_En;

//Internel Signals 
reg[2:0] Frame_count;
reg Frame_En;
wire previous_fval;
wire current_fval;

assign current_fval = iFVAL;
always @(posedge iCLK, posedge iRST) begin
	if (previous_fval === 0 && current_fval === 1) Frame_count = Frame_count + 3'b001 ;
	if( Frame_count % 5 == 0) begin
		Frame_En <= 1;
		Frame_count <= 0;
	end 
	else Frame_En <= 0;
end

assign previous_fval = current_fval;
assign oFrame_En = Frame_En;

endmodule