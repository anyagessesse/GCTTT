module MovementDetection (iCLK,
					      iRST,
					      iDVAL,
					      iFT_X,
					      iFT_Y, 
					      iFrame_En,
					      oGrid_Num,
					      oStable_hand,
					      );

input	      	iCLK;
input			iRST;
input	     	iDVAL;
input	[9:0]   iFT_X;
input	[9:0]   iFT_Y;
input			iFrame_En;
output 	[3:0]   oGrid_Num;
output			oStable_hand;
	
// State definition
localparam IDLE = 1'b0;
localparam DETECT = 1'b1;
localparam WIDTH = 640;
localparam HEIGHT = 480;
reg state, nxt_state; 

reg [3:0] counter;
reg grid_change;
reg [3:0] temp_grid_number;

always @(posedge iCLK, posedge iRST) begin
	if (iRST)
		state <= IDLE;
	else
		state <= nxt_state;
end

always @(*) begin
	//initialize SM inputs
	nxt_state = state;
	counter = 0;
	case (state)
 		IDLE: begin
			if(iFrame_En && iDVAL) begin
				nxt_state = DETECT;
			end
		end
		DETECT: begin
			nxt_state = IDLE;
			if (grid_change == 1'b0) counter = counter + 1'b1;
			else counter = 0;
		end
	endcase
end


// determine whether the grid is changed or not
always @(posedge iCLK) begin
	if(iFT_X < WIDTH/3)
    	temp_grid_number[3:2] <= 2'b00;
	else if (iFT_X > WIDTH/3 && iFT_X < 2*WIDTH/3) 
		temp_grid_number [3:2] <= 2'b01;
	else if(iFT_X > (2*WIDTH/3)) 
		temp_grid_number [3:2] <= 2'b10;
end	

always @(posedge iCLK) begin
	if(iFT_X < HEIGHT/3)
		temp_grid_number [1:0] <= 2'b01;
	else if (iFT_X > HEIGHT/3 && iFT_X < 2*HEIGHT/3)
		temp_grid_number [1:0] <= 2'b01;
	else if(iFT_X > (2*HEIGHT/3)) 
		temp_grid_number [1:0] <= 2'b01;

end	

assign oGrid_Num = temp_grid_number;


// indicate the hand is stable when the counter reaches 10
assign oStable_hand = (counter == 4'b1010) ? 1'b1 : 1'b0;

endmodule