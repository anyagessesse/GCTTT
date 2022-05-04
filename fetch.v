module fetch(clk, rst,newPC,instr,PC,PCPlus1,halt,jorb,haltPC,ldStallPC,ldStall,ipu_int,int_ack,int_output,leds);


	input clk;
	input rst;
	input [15:0]newPC, haltPC, ldStallPC; //what is the size of the PC?
	input halt;
	input jorb;
   input ldStall;
	input ipu_int;
	output [9:0]leds;


	output [15:0]instr;
	output [15:0]PC;
	output [15:0]PCPlus1;
        output int_ack;
	output int_output;

	wire [15:0]nextPC;
   wire [15:0]storedPC;
   wire int_done;
	reg int_in_progress;


	// decide next pc value
        assign nextPC = int_done ? storedPC : //get old pc after interrupt
								int_output ? 16'h0005 : //set PC to location of interrupt handler   
								jorb ? newPC :
		                  (instr[15:12] == 4'h0) ? PC :
								ldStall ? PC : PCPlus1;


        assign int_done = instr[15:12] == 4'b0011;
	assign int_output = int_in_progress ? 1'b0 : ipu_int;

	// dff to hold PC value
	dflop DFF0[15:0](.q(PC), .d(nextPC), .clk(clk), .rst(rst));

        //store old pc when jumping to interrupt
		  assign leds = {int_done,int_output, halt, jorb, ldStall,PC[4:0]};
        pcreg PCREG(.clk(clk),.rst(rst),.write_en(ipu_int & ~int_in_progress),.pc_in(PC),.pc_out(storedPC));
        //indicate that interrupt has been recieved
        dflop DFF1(.q(int_ack),.d(int_output),.clk(clk),.rst(rst));

	// adder to increment the PC 
	assign PCPlus1 = PC + 1;
	
	ram1port MEM0(.address(PC),.clock(clk),.data(16'h0000),.wren(1'b0),.q(instr));
	// fetch instruction from memory (how will memory work for instructions?)
	//memory2c MEM0(.data_out(instr), .data_in(16'h0000), .addr(PC), .enable(1'b1), .wr(1'b0), .createdump(1'b0), .clk(clk), .rst(rst));

	always @(posedge clk, posedge rst) begin
		if (rst) 
			int_in_progress <= 1'b0;
		else if(int_done)
			int_in_progress <= 1'b0;
		else if (ipu_int) 
			int_in_progress <= 1'b1;
	end


endmodule
