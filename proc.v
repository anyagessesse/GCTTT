module proc(clk,rst);

input clk, rst;

//signals
wire [15:0]FETCH_PC_in, FETCH_PC_out, DEC_PC_in, DEC_PC_out, EX_PC_in, 
	EX_PC_out, MEM_PC_in, MEM_PC_out, WB_PC_in, WB_PC_out;
wire [15:0]FETCH_PCPlus1, DEC_PCPlus1;
wire [15:0]FETCH_inst, DEC_inst_in, DEC_inst_out, EX_inst_in;
wire DEC_JumpOrBranchHigh, EX_JumpOrBranchHigh;
wire DEC_BranchHigh, EX_BranchHigh;
wire DEC_JumpHigh, EX_JumpHigh;
wire DEC_RqRdOrImm, EX_RqRdOrImm;
wire DEC_RsOrImm, EX_RsOrImm;
wire [3:0]DEC_ALUCtrl, EX_ALUCtrl;
wire DEC_MemWrite, EX_MemWrite, MEM_MemWrite;
wire DEC_MemRead, EX_MemRead, MEM_MemRead, WB_MemRead;
wire DEC_halt, EX_halt, MEM_halt, WB_halt;
wire [31:0]DEC_reg1_data, EX_reg1_data, MEM_reg1_data;
wire [31:0]DEC_reg2_data, EX_reg2_data, MEM_reg2_data;
wire [2:0]DEC_write_reg, EX_write_reg, MEM_write_reg, WB_write_reg;
wire DEC_write_en, EX_write_en, MEM_write_en, WB_write_en;
wire [31:0]EX_ALU_out, MEM_ALU_in, MEM_ALU_out, WB_ALU_in;
wire [31:0]MEM_MemData, WB_MemData;
wire [15:0]fd_inst;
wire [31:0]WB_WriteDataOut;
wire selectJorB;

//instantiate modules
/*
 * FETCH
 * inputs: clk, rst, newPC
 * outputs: instr, PC, PCPlus1
 */
fetch FETCH0(.clk(clk),.rst(rst),.newPC(EX_PC_out),.instr(FETCH_inst),.PC(FETCH_PC_out),.PCPlus1(FETCH_PCPlus1),.halt(WB_halt),.jorb(selectJorB));

dff DFF0[15:0](.q(DEC_PC_in), .d(FETCH_PC_out), .clk(clk), .rst(rst));
assign fd_inst = rst ? 16'h1000 : FETCH_inst;
dff DFF1[15:0](.q(DEC_inst_in), .d(fd_inst), .clk(clk), .rst(1'b0));
dff DFF2[15:0](.q(DEC_PCPlus1), .d(FETCH_PCPlus1), .clk(clk), .rst(rst));

/* 
 * DECODE
 * inputs: PC_fetch, PCPlus1, inst_fetch
 * ouputs: PCOut, inst_out, reg1_data, reg2_data,
 *         JumpOrBranchHigh, RqRdOrImm, RsOrImm, ALUCtrl,
 *         MemWrite, MemRead, halt, write_reg, write_en
 */

decode ID0(.clk(clk), .rst(rst), .PC(DEC_PC_in), .PCPlus1(DEC_PCPlus1), .inst(DEC_inst_in), .PCOut(DEC_PC_out), 
		 .inst_out(DEC_inst_out), .BranchHigh(DEC_BranchHigh), .JumpHigh(DEC_JumpHigh),
		 .RqRdOrImm(DEC_RqRdOrImm), .RsOrImm(DEC_RsOrImm), .ALUCtrl(DEC_ALUCtrl), 
		 .MemWrite(DEC_MemWrite), .MemRead(DEC_MemRead), .halt(DEC_halt),
		 .reg1_data(DEC_reg1_data), .reg2_data(DEC_reg2_data), .write_reg_out(DEC_write_reg),
		 .write_en_out(DEC_write_en), .write_en_in(WB_write_en), .write_reg_in(WB_write_reg), .write_data(WB_WriteDataOut));

dff DFF3[15:0](.q(EX_PC_in), .d(DEC_PC_out), .clk(clk), .rst(rst));
dff DFF4[15:0](.q(EX_inst_in), .d(DEC_inst_out), .clk(clk), .rst(rst));
dff DFF5(.q(EX_BranchHigh), .d(DEC_BranchHigh), .clk(clk), .rst(rst));
dff DFF34(.q(EX_JumpHigh), .d(DEC_JumpHigh), .clk(clk), .rst(rst));
dff DFF6(.q(EX_RqRdOrImm), .d(DEC_RqRdOrImm), .clk(clk), .rst(rst));
dff DFF7(.q(EX_RsOrImm), .d(DEC_RsOrImm), .clk(clk), .rst(rst));
dff DFF8[3:0](.q(EX_ALUCtrl), .d(DEC_ALUCtrl), .clk(clk), .rst(rst));
dff DFF9(.q(EX_MemWrite), .d(DEC_MemWrite), .clk(clk), .rst(rst));
dff DFF10(.q(EX_MemRead), .d(DEC_MemRead), .clk(clk), .rst(rst));
dff DFF11(.q(EX_halt), .d(DEC_halt), .clk(clk), .rst(rst));
dff DFF12[31:0](.q(EX_reg1_data), .d(DEC_reg1_data), .clk(clk), .rst(rst));
dff DFF13[31:0](.q(EX_reg2_data), .d(DEC_reg2_data), .clk(clk), .rst(rst));
dff DFF14[2:0](.q(EX_write_reg), .d(DEC_write_reg), .clk(clk), .rst(rst));
dff DFF15(.q(EX_write_en), .d(DEC_write_en), .clk(clk), .rst(rst));


/*
 * EXECUTE
 * inputs: PCIn, RqRd, Rs, instr, JumpOrBranchHigh, RqRdOrImm, RsOrImm,
 *         ALUCtrl
 * outputs: PC_ex, flush, reg1_out, ALUOut
 */
execute EX0(.PCIn(EX_PC_in),.RqRd(EX_reg1_data),.Rs(EX_reg2_data),
		.instr(EX_inst_in),.BranchHigh(EX_BranchHigh), .JumpHigh(EX_JumpHigh),
		.RqRdOrImm(EX_RqRdOrImm),.RsOrImm(EX_RsOrImm),.ALUCtrl(EX_ALUCtrl),
		.PCOut(EX_PC_out),.flush(EX_flush),.ALUOut(EX_ALU_out),.SelectJOrB(selectJorB));

dff DFF16[15:0](.q(MEM_PC_in), .d(EX_PC_out), .clk(clk), .rst(rst));
dff DFF17(.q(MEM_flush), .d(EX_flush), .clk(clk), .rst(rst));
dff DFF18[31:0](.q(MEM_ALU_in), .d(EX_ALU_out), .clk(clk), .rst(rst));
dff DFF19(.q(MEM_MemWrite), .d(EX_MemWrite), .clk(clk), .rst(rst));
dff DFF20(.q(MEM_MemRead), .d(EX_MemRead), .clk(clk), .rst(rst));
dff DFF21[31:0](.q(MEM_reg1_data), .d(EX_reg1_data), .clk(clk), .rst(rst));
dff DFF22[31:0](.q(MEM_reg2_data), .d(EX_reg2_data), .clk(clk), .rst(rst));
dff DFF23[2:0](.q(MEM_write_reg), .d(EX_write_reg), .clk(clk), .rst(rst));
dff DFF24(.q(MEM_write_en), .d(EX_write_en), .clk(clk), .rst(rst));
dff DFF33(.q(MEM_halt), .d(EX_halt), .clk(clk), .rst(rst));

/*
 * MEMORY
 * inputs: PC, flush, ALURes, RdRqIn, Mem_Write
 * outputs: PCOut, ReadDataOut, ALUOut
 */
memory MEM0(.flush(MEM_flush), .RdRqIn(MEM_reg1_data), .ALURes(MEM_ALU_in), 
		.Mem_Write(MEM_MemWrite), .ReadDataOut(MEM_MemData),
		.ALUOut(MEM_ALU_out));

dff DFF25[15:0](.q(WB_PC_in), .d(MEM_PC_in), .clk(clk), .rst(rst));
dff DFF26[31:0](.q(WB_MemData), .d(MEM_MemData), .clk(clk), .rst(rst));
dff DFF27[31:0](.q(WB_ALU_in), .d(MEM_ALU_out), .clk(clk), .rst(rst));
dff DFF28(.q(WB_MemRead), .d(MEM_MemRead), .clk(clk), .rst(rst));
dff DFF29[2:0](.q(WB_write_reg), .d(MEM_write_reg), .clk(clk), .rst(rst));
dff DFF30[2:0](.q(WB_write_en), .d(MEM_write_en), .clk(clk), .rst(rst));
dff DFF32(.q(WB_halt), .d(MEM_halt), .clk(clk), .rst(rst));

/* WRITEBACK
 * inputs: PC, ALURes, MemRead, MemReadDataIn, write_reg, write_en
 * outputs: PCNew, WriteDataOut, WriteRegOut, write_en_out
 */
write WB0(.PC(WB_PC_in), .ALURes(WB_ALU_in), .MemReadDataIn(WB_MemData),
          .MemRead(WB_MemRead), .PCNew(WB_PC_in), .WriteDataOut(WB_WriteDataOut));


endmodule
