`timescale 1ns / 1ps

module top_test_sender (
    output wire serial_out,
    input  wire clk
);
  wire clk_100;
  wire aresetn;
  clk_wiz_0 pll (
      .clk_in1 (clk),
      .clk_out1(clk_100),
      .locked  (aresetn)

  );
  test_pattern tp1 (
      .clk(clk_100),
      .aresetn(aresetn),
      .serial_out(serial_out)
  );
endmodule
