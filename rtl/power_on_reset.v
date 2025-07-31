`timescale 1ns/1ps

module power_on_reset (
    input  wire clk,         // Clock after FPGA config
    output wire reset_n      // Active-low reset output
  );

  parameter DELAY_CYCLES = 160;

  reg [$clog2(DELAY_CYCLES):0] counter ;
  reg reset_done ;
  initial
    begin
      counter = 0;
      reset_done = 0;
    end

  always @(posedge clk)
    begin
      if (!reset_done)
        begin
          counter <= counter + 1;
          if (counter == (DELAY_CYCLES - 1))
            reset_done <= 1'b1;
        end
    end

  assign reset_n = reset_done;

endmodule
