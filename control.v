control (opcode, JumpOrBranchHigh, RqRqOrImm, RsOrImm, ALUCtrl);

    input [3:0]opcode;

    output JumpOrBranchHigh;
    output RdRqOrImm;
    output RsOrImm;
    output [?:0]ALUCtrl;   //size?

endmodule 
