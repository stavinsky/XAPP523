
`timescale 1ns / 1ps

module top_receiver_xilinix (
    input  wire clk,
    input  wire serial_in_p,
    input  wire serial_in_n,
    output wire test_out
);

  wire aresetn;
  wire clk_54;
  wire clk_54_90;
  wire clk_200;
  wire clk_fb;
  wire clk_div;
  wire clk_dbg;
  wire clk_100;
  wire clk_serial_out;
  clk_wiz_0_1 pll1 (
      .clk_in1(clk),
      .locked(aresetn),
      .clk_0(clk_54),
      .clk_90(clk_54_90),
      .clk_200(clk_200),
      .clk_div(clk_div),
      .clk_dbg(clk_dbg),
      .clkfb_in(clk_fb),
      .clkfb_out(clk_fb),
      .clk_100(clk_100),
      .serial_out_clk(clk_serial_out)
  );
  wire clk_54_buf;
  wire clk_54_90_buf;

  /* verilator lint_off MODMISSING */
  BUFIO bufio1 (
      .I(clk_54),
      .O(clk_54_buf)
  );
  BUFIO bufio2 (
      .I(clk_54_90),
      .O(clk_54_90_buf)
  );

  /* verilator lint_on MODMISSING */
  (* MARK_DEBUG="true" *) wire [7:0] sample_window;
  oversample oversample_inst (
      .clk_ref(clk_200),
      .aresetn(aresetn),
      .clk(clk_54_buf),
      .clk_90(clk_54_90_buf),
      .serial_in_p(serial_in_p),
      .serial_in_n(serial_in_n),
      .sample_window(sample_window)
  );

  wire [7:0] sw;
  (* MARK_DEBUG="true" *)wire [2:0] out;

  data_recovery_unit dru (
      .sample_window(sample_window),
      .clk(clk_100),
      .aresetn(aresetn),
      .out(out)
  );
  assign test_out = clk_serial_out;
endmodule

