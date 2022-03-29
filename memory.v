module memory(PC, flush, RdRq, ALURes, WBReg_In, Mem_Write, Mem_Read_In, 
		Reg_Write_Out, PCOut, DataOut, ALUOut WBReg_Out, Reg_Write_Out, Mem_Read_Out);

    input [12:0]PC;
    input flush;
    input [31:0]WriteDataIn;
    input [31:0]ALURes;
    input Mem_Write;	//1 = write to memory
    input Reg_Write_In;	//1 = write to register, passed through for WB
    input Mem_Read_In; // control signal for WB
    input [2:0]WBReg_In;	//register used in WB

    output [12:0]PCOut;
    output [31:0]ReadDataOut;
    output [31:0]ALUOut;
    output [2:0]WBReg_Out;
    output Reg_Write_Out;
    output Mem_Read_Out;


    //pass signals through to next stage
    assign PCOut = PC;
    assign ALUOut = ALURes;
    assign WBReg_Out = WBReg_In;
    assign Reg_Write_Out = Reg_Write_In;
    assign Mem_Read_Out = Mem_Read_In;

    //memory stuff here :) use WriteDataIn, ALURes, Mem_Write

  
endmodule
