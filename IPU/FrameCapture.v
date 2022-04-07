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
reg previous_fval;
wire current_fval;
reg check;
assign current_fval = iFVAL;
//assign check = (Frame_count == 3'b100) ? 1'b1 : 1'b0;


always @(posedge iCLK, posedge iRST) begin
	if (iRST) begin
		Frame_count <= 0;
	end
	else if(check == 1'b1) begin
		Frame_count <= 0;
	end 
	else if (previous_fval == 1) begin
		Frame_count <= Frame_count + 3'b001 ;
	end
	else Frame_count <= Frame_count;
end

always @(*) begin
	if(Frame_count == 3'b100) 
		check <= 1'b1;
	else
		check <= 1'b0;
end
always @(posedge iCLK, posedge iRST) begin
	if (iRST) previous_fval <= 1'b0;
	else previous_fval <= current_fval;
		
end

assign oFrame_En = (Frame_count == 3'b100) ? 1'b1 : 1'b0;

endmodule