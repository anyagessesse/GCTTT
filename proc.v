module proc(clk,rst);

input clk, rst;

//instantiate modules
/*
 * FETCH
 * inputs: clk, rst, newPC
 * outputs: inst_fetch, PC_fetch, PCPlus1
 */
fetch FETCH0(clk,rst,newPC,instr,PC,PCPlus1);
/* 
 * DECODE
 * inputs: PC_fetch, PCPlus1, inst_fetch
 * ouputs: 
 *     -to EX: PC_id, JumpOrBranchHigh, RqRdOrImm, RsOrImm, ALUCtrl, inst_id
 *     -to MEM: MemWrite, MemRead
 *     -to WB: write_en, write_reg
 *     -to rf: RqRd, Rs
 */
decode ID0(PC_fetch,PCPlus1,inst_fetch,PC_id,inst_id,RqRd,Rs,write_en,
                write_reg, JumpOrBranchHigh,RqRdOrImm,RsOrImm,ALUCtrl,
		MemWrite,MemRead);
/*
 * EXECUTE
 * inputs: PC_id, reg1_data, reg2_data, inst_id, JumpOrBranchHigh,
 *          RqRdOrImm, RsOrImm, ALUCtrl
 * outputs: PC_ex, flush, reg1_out, ALUOut
 */
execute EX0(PC_id,reg1_data,reg2_data,inst_id,JumpOrBrachHigh,RqRdOrImm,
		RsOrImm,ALUCtrl,PC_ex,flush,reg1_out,ALUOut);
/*
 * MEMORY
 * inputs: PC_ex, flush, req1_out, ALUOut, MemWrite
 * outputs: 
 *    -to WB: PC_mem, DataOut, ALUOut_mem, DataOut_mem
 */
memory MEM0(PC, flush, req1_out, ALUOut, MemWrite, 
		PC_mem, DataOut, 
		ALUOut_mem, DataOut_mem);
/* WRITEBACK
 * inputs: PC_ex, ALUOut_mem, write_reg, write_en, MemRead, DataOut
 * outputs: PCnew, WriteData, WriteReg, write_en_out
 */
write WB0(PC_ex,ALUOut_mem, DataOut, write_reg, MemRead, PCnew, 
		WriteData, WriteReg, write_en_out);

//regsiters
rf REG0(clk, rst, RqRd, Rs, WriteReg, 
		WriteData, write_en_out, reg1_data, reg2_data);


endmodule
