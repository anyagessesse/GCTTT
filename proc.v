module proc(clk,rst,leds, sw, pixel_addr, pixel_value, pixel_en, ipu_int, int_ack, grid_coord);

input clk, rst;
input [1:0] sw;
input ipu_int;
input [3:0]grid_coord;
output [9:0]leds;
output [31:0]pixel_addr;
output pixel_en, pixel_value;
output int_ack;

//signals
wire [15:0]FETCH_PC_out, DEC_PC_in, DEC_PC_out, EX_PC_in, 
	EX_PC_out, MEM_PC_in, WB_PC_in;
wire [15:0]FETCH_PCPlus1, DEC_PCPlus1;
wire [15:0]FETCH_inst, DEC_inst_in, DEC_inst_out, EX_inst_in, MEM_inst_in,WB_inst_in;
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
wire [31:0]fRqRdData,fRsData;
wire [2:0]DEC_write_reg, EX_write_reg, MEM_write_reg, WB_write_reg;
wire DEC_write_en, EX_write_en, MEM_write_en, WB_write_en;
wire [31:0]EX_ALU_out, MEM_ALU_in, MEM_ALU_out, WB_ALU_in;
wire [31:0]MEM_RegData, WB_RegData;
wire [15:0]fd_inst;
wire selectJorB;
wire [2:0]DEC_RqRd,DEC_Rs,EX_RqRd,EX_Rs;
wire EX_flush,MEM_flush;
wire [15:0]WBMEMPC;
wire WBMEMhalt;
wire ldStall;
wire branchhigh;
wire jumphigh;
wire memwrite;
wire memread;
wire halt1;
wire writeen;
wire nxt_stall;
wire [15:0]stall_inst;
wire DEC_int_done, EX_int_done, MEM_int_done, WB_int_done, int_done;
//instantiate modules
/*
 * FETCH
 * inputs: clk, rst, newPC
 * outputs: instr, PC, PCPlus1
 */
fetch FETCH0(.clk(clk),.rst(rst),.newPC(EX_PC_out),.instr(FETCH_inst),.PC(FETCH_PC_out),.PCPlus1(FETCH_PCPlus1),.halt(WB_halt),.jorb(selectJorB),
		.haltPC(WB_PC_in),.ldStall(ldStall),.ldStallPC(DEC_PC_in), .ipu_int(ipu_int), .int_ack(int_ack),.int_done(WB_int_done));

dflop DFF0[15:0](.q(DEC_PC_in), .d(FETCH_PC_out), .clk(clk), .rst(rst | EX_flush|WB_halt|EX_halt));
assign fd_inst = (rst | EX_flush) ? 16'h1000 : WB_halt|EX_halt ? 16'h0000 :  ldStall ? DEC_inst_in : FETCH_inst;
dflop DFF1[15:0](.q(DEC_inst_in), .d(fd_inst), .clk(clk), .rst(1'b0));
dflop DFF2[15:0](.q(DEC_PCPlus1), .d(FETCH_PCPlus1), .clk(clk), .rst(rst | EX_flush|WB_halt|EX_halt|ldStall));

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
		 .write_en_out(DEC_write_en), .write_en_in(WB_write_en), .write_reg_in(WB_write_reg), .write_data(WB_RegData),
		 .RqRd(DEC_RqRd),.Rs(DEC_Rs), .leds(leds), .sw(sw), .pixel_en(pixel_en), .pixel_value(pixel_value), 
                 .pixel_addr(pixel_addr),.int_done(DEC_int_done));

assign ldStall = EX_MemRead & (EX_write_reg == DEC_Rs | EX_write_reg == DEC_RqRd) ? 1 : 0;


assign branchhigh = ldStall ? 1'b0 : DEC_BranchHigh;
assign jumphigh = ldStall ? 1'b0 : DEC_JumpHigh;
assign memwrite = ldStall? 1'b0 : DEC_MemWrite;
assign memread = ldStall? 1'b0 : DEC_MemRead;
assign halt1 = ldStall? 1'b0 : DEC_halt;
assign writeen = ldStall? 1'b0 : DEC_write_en;
assign stall_inst = ldStall ? EX_inst_in : DEC_inst_out;
assign int_done = ldStall ? 1'b0 : DEC_int_done;

dflop DFF50(.q(nxt_stall), .d(ldStall), .clk(clk), .rst(rst | MEM_flush|WB_halt|MEM_halt));
dflop DFF3[15:0](.q(EX_PC_in), .d(DEC_PC_out), .clk(clk), .rst(rst | MEM_flush|WB_halt|MEM_halt));
dflop DFF4[15:0](.q(EX_inst_in), .d(stall_inst), .clk(clk), .rst(rst | MEM_flush|WB_halt|MEM_halt));
dflop DFF5(.q(EX_BranchHigh), .d(branchhigh), .clk(clk), .rst(rst | MEM_flush|WB_halt|MEM_halt));
dflop DFF34(.q(EX_JumpHigh), .d(jumphigh), .clk(clk), .rst(rst | MEM_flush|WB_halt|MEM_halt));
dflop DFF6(.q(EX_RqRdOrImm), .d(DEC_RqRdOrImm), .clk(clk), .rst(rst | MEM_flush|WB_halt|MEM_halt));
dflop DFF7(.q(EX_RsOrImm), .d(DEC_RsOrImm), .clk(clk), .rst(rst | MEM_flush|WB_halt|MEM_halt));
dflop DFF8[3:0](.q(EX_ALUCtrl), .d(DEC_ALUCtrl), .clk(clk), .rst(rst | MEM_flush|WB_halt|MEM_halt));
dflop DFF9(.q(EX_MemWrite), .d(memwrite), .clk(clk), .rst(rst | MEM_flush|WB_halt|MEM_halt));
dflop DFF10(.q(EX_MemRead), .d(memread), .clk(clk), .rst(rst | MEM_flush|WB_halt|MEM_halt));
dflop DFF11(.q(EX_halt), .d(halt1), .clk(clk), .rst(rst | MEM_flush|WB_halt|MEM_halt));
dflop DFF12[31:0](.q(EX_reg1_data), .d(DEC_reg1_data), .clk(clk), .rst(rst | MEM_flush|WB_halt|MEM_halt));
dflop DFF13[31:0](.q(EX_reg2_data), .d(DEC_reg2_data), .clk(clk), .rst(rst | MEM_flush|WB_halt|MEM_halt));
dflop DFF14[2:0](.q(EX_write_reg), .d(DEC_write_reg), .clk(clk), .rst(rst | MEM_flush|WB_halt|MEM_halt));
dflop DFF15(.q(EX_write_en), .d(writeen), .clk(clk), .rst(rst | MEM_flush|WB_halt|MEM_halt));
dflop DFF43[2:0](.q(EX_RqRd), .d(DEC_RqRd), .clk(clk), .rst(rst | MEM_flush|WB_halt|MEM_halt));
dflop DFF44[2:0](.q(EX_Rs), .d(DEC_Rs), .clk(clk), .rst(rst | MEM_flush|WB_halt|MEM_halt));
dflop DFF56(.q(EX_int_done), .d(int_done), .clk(clk), .rst(rst | MEM_flush|WB_halt|MEM_halt));


/*
 * EXECUTE
 * inputs: PCIn, RqRd, Rs, instr, JumpOrBranchHigh, RqRdOrImm, RsOrImm,
 *         ALUCtrl
 * outputs: PC_ex, flush, reg1_out, ALUOut
 */


ALUForward ALUF0(.WB_RdData_in(WB_RegData),.MEM_RdData_in(MEM_RegData),.RqRdData(EX_reg1_data),.RsData(EX_reg2_data),.WB_Rd_in(WB_inst_in[11:9]),.MEM_Rd_in(MEM_inst_in[11:9]),.RqRd(EX_RqRd),.Rs(EX_Rs),.PrevWriteEn(MEM_write_en),.PrevPrevWriteEn(WB_write_en),.PrevMemRead(MEM_MemRead),.PrevPrevMemRead(WB_MemRead),.fRqRdData(fRqRdData),.fRsData(fRsData));


execute EX0(.PCIn(EX_PC_in),.RqRd(fRqRdData),.Rs(fRsData),
		.instr(EX_inst_in),.BranchHigh(EX_BranchHigh), .JumpHigh(EX_JumpHigh),
		.RqRdOrImm(EX_RqRdOrImm),.RsOrImm(EX_RsOrImm),.ALUCtrl(EX_ALUCtrl),
		.PCOut(EX_PC_out),.flush(EX_flush),.ALUOut(EX_ALU_out),.SelectJOrB(selectJorB));



dflop DFF16[15:0](.q(MEM_PC_in), .d(EX_PC_out), .clk(clk), .rst(rst|WB_halt));
dflop DFF17(.q(MEM_flush), .d(EX_flush), .clk(clk), .rst(rst|WB_halt));
dflop DFF18[31:0](.q(MEM_ALU_in), .d(EX_ALU_out), .clk(clk), .rst(rst|WB_halt));
dflop DFF19(.q(MEM_MemWrite), .d(EX_MemWrite), .clk(clk), .rst(rst|WB_halt));
dflop DFF20(.q(MEM_MemRead), .d(EX_MemRead), .clk(clk), .rst(rst|WB_halt));
dflop DFF21[31:0](.q(MEM_reg1_data), .d(EX_reg1_data), .clk(clk), .rst(rst|WB_halt));
dflop DFF22[31:0](.q(MEM_reg2_data), .d(EX_reg2_data), .clk(clk), .rst(rst|WB_halt));
dflop DFF23[2:0](.q(MEM_write_reg), .d(EX_write_reg), .clk(clk), .rst(rst|WB_halt));
dflop DFF24(.q(MEM_write_en), .d(EX_write_en), .clk(clk), .rst(rst|WB_halt));
dflop DFF33(.q(MEM_halt), .d(EX_halt), .clk(clk), .rst(rst|WB_halt));
dflop DFF40[15:0](.q(MEM_inst_in), .d(EX_inst_in), .clk(clk), .rst(rst|WB_halt));
dflop DFF57(.q(MEM_int_done), .d(EX_int_done), .clk(clk), .rst(rst|WB_halt));


/*
 * MEMORY
 * inputs: PC, flush, ALURes, RdRqIn, Mem_Write
 * outputs: PCOut, ReadDataOut, ALUOut
 */
memory MEM0(.flush(MEM_flush), .RdRqIn(MEM_reg1_data), .ALURes(MEM_ALU_in), 
		.Mem_Write(MEM_MemWrite), .ALUOut(MEM_ALU_out), .MemRead(MEM_MemRead), 
                .WriteRegDataOut(MEM_RegData), .clk(clk), .rst(rst),.Mem_Addr(MEM_inst_in[5:0]));




assign WBMEMPC = WB_halt ? WB_PC_in : MEM_PC_in;
assign WBMEMhalt = WB_halt ? WB_halt : MEM_halt;

dflop DFF25[15:0](.q(WB_PC_in), .d(WBMEMPC), .clk(clk), .rst(rst));
dflop DFF26[31:0](.q(WB_RegData), .d(MEM_RegData), .clk(clk), .rst(rst|WB_halt));
dflop DFF27[31:0](.q(WB_ALU_in), .d(MEM_ALU_out), .clk(clk), .rst(rst|WB_halt));
dflop DFF28(.q(WB_MemRead), .d(MEM_MemRead), .clk(clk), .rst(rst|WB_halt));
dflop DFF29[2:0](.q(WB_write_reg), .d(MEM_write_reg), .clk(clk), .rst(rst|WB_halt));
dflop DFF30(.q(WB_write_en), .d(MEM_write_en), .clk(clk), .rst(rst|WB_halt));
dflop DFF32(.q(WB_halt), .d(WBMEMhalt), .clk(clk), .rst(rst));
dflop DFF41[15:0](.q(WB_inst_in), .d(MEM_inst_in), .clk(clk), .rst(rst|WB_halt)); 
dflop DFF58(.q(WB_int_done), .d(MEM_int_done), .clk(clk), .rst(rst|WB_halt));

/* WRITEBACK
 * inputs: PC, ALURes, MemRead, MemReadDataIn, write_reg, write_en
 * outputs: PCNew, WriteDataOut, WriteRegOut, write_en_out
 */
write WB0(.ALURes(WB_ALU_in), .MemReadDataIn(WB_RegData), .MemRead(WB_MemRead));


endmodule
