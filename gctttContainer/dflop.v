module dflop(q, d, clk, rst);

    output         q;
    input          d;
    input          clk;
    input          rst;

    reg            state;

    assign #(1) q = state;

    always @(posedge clk, posedge rst) begin
      state = rst? 0 : d;
    end

endmodule

