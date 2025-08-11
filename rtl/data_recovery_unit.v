module data_recovery_unit (
    input wire [7:0] sample_window,
    input wire clk,
    output reg [7:0] sw,
    output reg [3:0] E
);
  //   reg [7:0] sw;
  always @(posedge clk) begin
    sw <= sample_window;
  end
  reg q7_prev;
  always @(posedge clk) begin
    q7_prev <= sw[7];
  end

  //   (* MARK_DEBUG="true" *) reg [3:0] E;

  //  end
  // verilog_lint: waive-start always-comb
  always @(*) begin
    E[0] = (sw[1] ^ ~sw[0]) | (sw[5] ^ ~sw[4]);
    E[1] = (sw[1] ^ ~sw[2]) | (sw[5] ^ ~sw[6]);
    E[2] = (sw[2] ^ ~sw[3]) | (sw[7] ^ ~sw[6]);
    E[3] = (sw[4] ^ ~sw[3]) | (sw[0] ^ ~q7_prev);
  end
  // verilog_lint: waive-stop always-comb

endmodule
