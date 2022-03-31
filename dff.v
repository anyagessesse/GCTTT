module dff (q, d, clk, rst);

    output         [15:0]q;
    input          [15:0]d;
    input          clk;
    input          rst;

    reg            [15:0]state;

    assign #(1) q = state;

    always @(posedge clk) begin
      state = rst? 0 : d;
    end

endmodule

