`timescale 1ns / 1ps
module tb_manchester_encoder;

  // Inputs
  reg clk;
  reg rst;
  reg valid;
  reg [7:0] data_in;

  // Outputs
  wire ready;
  wire serial_out;


  manchester_serial_top manch_top(
                          .clk(clk),
                          .rst(rst),
                          .valid(valid),
                          .data_in(data_in),
                          .serial_out(serial_out),
                          .ready(ready)
                        );
  // Clock generation: 100 MHz
  always #5 clk = ~clk;

  initial
    begin
      $dumpfile("tb_manchester_encoder.vcd");   // name of the waveform file
      $dumpvars(0, tb_manchester_encoder); // level 0 dumps all vars in module


      // Initial values
      clk = 0;
      rst = 1;
      valid = 0;
      data_in = 8'b0;

      // Reset pulse
      #20;
      rst = 0;

      // Test vector 1: 8'b10101010
      #10;
      #50
       data_in = 8'b11001100;
      valid = 1;
      wait (ready == 1);
      #20;
      data_in = 8'b01010101;
      wait (ready == 1);
      #20;
      data_in = 8'b11110000;
      wait (ready == 1);
      #20;
      wait (ready == 1);
      #20;
      valid = 0;
      // #10;
      // valid = 1'b1;
      // valid=0;



      #4000;
      $finish;
    end

endmodule
