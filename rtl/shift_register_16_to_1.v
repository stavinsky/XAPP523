`timescale 1ns / 1ps
module shift_register_16_to_1 (
    input  wire       clk,
    input  wire       rst,
    input  wire       load,
    input  wire [15:0] data_in,
    output reg        bit_out,
    output reg        ready
  );

  reg [15:0] shift_reg;
  reg [4:0]  bit_cnt;
  reg        shifting;

  always @(posedge clk)
    begin
      if (rst)
        begin
          shift_reg <= 0;
          bit_cnt   <= 0;
          bit_out   <= 0;
          ready     <= 1;
          shifting  <= 0;
        end
      else
        begin

          if (load && ~shifting)
            begin
              ready <= 0;
              bit_cnt   <= 15;
              shifting  <= 1;
              bit_out   <= data_in[15];
              shift_reg <= {data_in[14:0], 1'b0};
            end
          else if (shifting)
            // ready <= 0;
            begin
              bit_out   <= shift_reg[15];
              shift_reg <= {shift_reg[14:0], 1'b0};
              bit_cnt   <= bit_cnt - 1;
              if (bit_cnt == 2)  begin
                  // this will trigger ready on bit_cnt = 1; 
                  // client will upload data and send load on the next clock
                  ready    <= 1;
              end 

              if (bit_cnt == 1)
                begin
                  shifting <= 0;
                end
            end
        end
    end
endmodule
