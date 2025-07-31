`timescale 1ns / 1ps

module counter(
    input clock,
    input tready,
    output tvalid,
    output [7:0]tdata
  );
  reg [7:0]cnt;
  assign tdata = cnt;
  assign tvalid = 1'b1;
  always @(posedge clock)
    begin
      if (tready)
        begin
          cnt <= cnt + 1'b1;
        end
    end
endmodule
