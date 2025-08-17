`timescale 1ns / 1ps
`include "assert_utils.vh"
`default_nettype none

module tb_data_recovery_unit ();
  reg aclk;
  reg aresetn;
  initial aclk = 0;
  localparam CLK_PERIOD = 10;
  always #(CLK_PERIOD / 2) aclk = ~aclk;
  reg  [7:0] data_in;
  wire [7:0] sample_window;
  assign sample_window = {
    ~data_in[0],
    data_in[1],
    ~data_in[2],
    data_in[3],
    ~data_in[4],
    data_in[5],
    ~data_in[6],
    data_in[7]
  };
  data_recovery_unit dru (
      .clk(aclk),
      .aresetn(aresetn),
      .sample_window(sample_window)

  );
  initial begin
    $dumpfile("tb_data_recovery_unit.vcd");
    $dumpvars(0, tb_data_recovery_unit);
    aresetn = 0;
    repeat (5) @(posedge aclk);
    aresetn = 1;

    @(posedge aclk);
    data_in = 8'b11110000;
    @(posedge aclk);
    data_in = 8'b11100001;
    @(posedge aclk);
    data_in = 8'b11000011;
    @(posedge aclk);
    data_in = 8'b10000111;
    @(posedge aclk);
    data_in = 8'b00001111;
    @(posedge aclk);
    data_in = 8'b00011110;
    @(posedge aclk);
    data_in = 8'b00111100;
    @(posedge aclk);
    data_in = 8'b01111000;
    @(posedge aclk);
    data_in = 8'b11110000;
    @(posedge aclk);


    repeat (10) @(posedge aclk);
    $finish();
  end


endmodule

