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

//Internel Signals 
reg [14:0] min_x;
reg [14:0] y_of_minx;
localparam SCREEN_WIDTH = 14'd640;
localparam SCREEN_HEIGHT = 14'd480;

always @(posedge iCLK, posedge iRST) begin
    if (iDCLEAN == 1'b1 && iDVAL == 1'b1) begin// skin
        // store the current minimum x of the skin pixels
        if (iX_Cont[15:1] < min_x) begin
            min_x = iX_Cont[15:1];
            y_of_minx = iY_Cont[15:1];
        end
    end
end

// determine if the fingertip is found for the current frame 
assign oDVAL = (iX_Cont[15:1] == SCREEN_WIDTH && iY_Cont[15:1] == SCREEN_HEIGHT) ? 1'b1: 1'b0;
assign oFT_X = oDVAL ? min_x[9:0] : 0;
assign oFT_Y = oDVAL ? y_of_minx[9:0] : 0;

endmodule