`timescale 1ns / 1ps
`include "assert_utils.vh"
`default_nettype none

module tb_manchester_decoder2 ();
  reg aclk;
  reg aresetn;
  initial aclk = 0;
  localparam CLK_PERIOD = 10;
  always #(CLK_PERIOD / 2) aclk = ~aclk;


  reg [2:0] bits;
  reg [2:0] num_bits;
  manchester_decoder2 dut (
      .aclk(aclk),
      .aresetn(aresetn),
      .bits(bits),
      .num_bits(num_bits)

  );
  reg [55:0] pattern = 56'hAAAAD5AABBCCDD;


  localparam integer WIDTH = 56;  // set as needed

  function [2*WIDTH-1:0] manchester_encode;
    input [WIDTH-1:0] d;  // MSB at d[WIDTH-1]
    integer i;
    begin
      for (i = 0; i < WIDTH; i = i + 1)
      manchester_encode[2*(WIDTH-1-i)+:2] = d[WIDTH-1-i] ? 2'b01 : 2'b10;
    end
  endfunction

  wire [111:0] manchester = manchester_encode(pattern);

  integer it = 111;
  task automatic send_bits;
    input reg [2:0] num;
    begin
      num_bits = num;
      case (num)
        1:       bits = {2'b00, manchester[it]};  // 1 bit
        2:       bits = {1'b0, manchester[it-:2]};  // 2 bits
        3:       bits = manchester[it-:3];  // 3 bits
        default: bits = 3'b000;
      endcase
      it = it - num;  // move pointer down
      @(posedge aclk);
    end
  endtask
  initial begin
    $dumpfile("tb_manchester_decoder2.vcd");
    $dumpvars(0, tb_manchester_decoder2);
    aresetn = 0;
    repeat (5) @(posedge aclk);
    aresetn = 1;

    send_bits(2);
    send_bits(2);
    send_bits(2);
    send_bits(2);
    send_bits(2);
    send_bits(2);
    send_bits(2);
    send_bits(2);

    send_bits(2);
    send_bits(2);
    send_bits(2);
    send_bits(2);
    send_bits(2);
    send_bits(2);
    send_bits(2);
    send_bits(2);

    send_bits(2);
    send_bits(2);
    send_bits(2);
    send_bits(2);
    send_bits(2);
    send_bits(2);
    send_bits(2);
    send_bits(2);





    repeat (10) @(posedge aclk);
    $finish();
  end


endmodule

