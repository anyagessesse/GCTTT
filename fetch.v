module fetch(clk, rst,newPC,instr,PC,PCPlus1,halt,jorb,haltPC,ldStallPC,ldStall,ipu_int,int_ack,int_done);


	input clk;
	input rst;
	input [15:0]newPC, haltPC, ldStallPC; //what is the size of the PC?
	input halt;
	input jorb;
        input ldStall;
	input ipu_int;
        input int_done;


	output [15:0]instr;
	output [15:0]PC;
	output [15:0]PCPlus1;
        output int_ack;

	wire [15:0]nextPC;
        wire [15:0]storedPC;


	// decide next pc value
        assign nextPC = ipu_int ? 16'h0005 : //set PC to location of interrupt handler
                        int_done ? storedPC : //get old pc after interrupt
                        halt ? haltPC :
			jorb ? newPC :
			ldStall ? PC :
			PCPlus1;


	// dff to hold PC value
	dflop DFF0[15:0](.q(PC), .d(nextPC), .clk(clk), .rst(rst));

        //store old pc when jumping to interrupt
        pcreg PCREG(.clk(clk),.rst(rst),.write_en(ipu_int),.pc_in(PC),.pc_out(storedPC));
        //indicate that interrupt has been recieved
        dflop DFF1(.q(int_ack),.d(ipu_int),.clk(clk),.rst(rst));

	// adder to increment the PC (what value to increment by?)
	assign PCPlus1 = PC + 1;
	
	//ram1port MEM0(.address(PC),.clock(clk),.data(16'h0000),.wren(1'b0),.q(instr));
	// fetch instruction from memory (how will memory work for instructions?)
	memory2c MEM0(.data_out(instr), .data_in(16'h0000), .addr(PC), .enable(1'b1), .wr(1'b0), .createdump(1'b0), .clk(clk), .rst(rst));


endmodule
