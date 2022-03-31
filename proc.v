module proc(clk,rst);

input clk, rst;

//signals
wire clk, rst;
wire [15:0]PCNew, PCPlus1, PC_fetch, PC_id, PC_ex, PC_mem;
wire [15:0]inst_fetch, inst_id;
wire JumpOrBranchHigh, RqRdOrImm, RsOrImm, MemWrite, MemRead, write_en;
wire [3:0] ALUCtrl;
wire [2:0]write_reg, WriteReg, RqRd, Rs;
wire flush, halt, write_en_out;
wire [31:0]reg1_data, reg2_data, ALUOut, ALUOut_mem, WriteData, DataOut;

//instantiate modules
/*
 * FETCH
 * inputs: clk, rst, newPC
 * outputs: inst_fetch, PC_fetch, PCPlus1
 */
fetch FETCH0(clk,rst,PCNew,inst_fetch,PC_fetch,PCPlus1);
/* 
 * DECODE
 * inputs: PC_fetch, PCPlus1, inst_fetch
 * ouputs: halt
 *     -to EX: PC_id, JumpOrBranchHigh, RqRdOrImm, RsOrImm, ALUCtrl, inst_id
 *     -to MEM: MemWrite, MemRead
 *     -to WB: write_en, write_reg
 *     -to rf: RqRd, Rs  
 */
decode ID0(PC_fetch,PCPlus1,inst_fetch,PC_id,inst_id,RqRd,Rs,write_en,
                write_reg, JumpOrBranchHigh,RqRdOrImm,RsOrImm,ALUCtrl,
		MemWrite,MemRead,halt);
/*
 * EXECUTE
 * inputs: PC_id, reg1_data, reg2_data, inst_id, JumpOrBranchHigh,
 *          RqRdOrImm, RsOrImm, ALUCtrl
 * outputs: PC_ex, flush, reg1_out, ALUOut
 */
execute EX0(.PCIn(PC_id),.RqRd(reg1_data),.Rs(reg2_data),
		.instr(inst_id),.JumpOrBranchHigh(JumpOrBranchHigh),
		.RqRdOrImm(RqRdOrImm),.RsOrImm(RsOrImm),.ALUCtrl(ALUCtrl),
		.PCOut(PC_ex),.flush(flush),.ALUOut(ALUOut));

/*
 * MEMORY
 * inputs: PC_ex, flush, req1_out, ALUOut, MemWrite
 * outputs: 
 *    -to WB: PC_mem, DataOut, ALUOut_mem, DataOut_mem
 */
memory MEM0(.PC(PC_ex), .flush(flush), .RdRqIn(reg1_data), .ALURes(ALUOut), 
		.Mem_Write(MemWrite), .PCOut(PC_mem), .ReadDataOut(DataOut_mem),
		.ALUOut(ALUOut_mem));

/* WRITEBACK
 * inputs: PC_ex, ALUOut_mem, write_reg, write_en, MemRead, DataOut
 * outputs: PCNew, WriteData, WriteReg, write_en_out
 */
write WB0(.PC(PC_ex), .ALURes(ALUOut_mem), .MemReadDataIn(DataOut_mem), .WriteRegIn(write_reg), 
		.write_en(write_en), .MemRead(MemRead), .PCNew(PCNew), .WriteDataOut(WriteData),
                .WriteRegOut(WriteReg), .write_en_out(write_en_out));

//regsiters
rf REG0(clk, rst, RqRd, Rs, WriteReg, 
		WriteData, write_en_out, reg1_data, reg2_data);


endmodule
