`timescale 1ns / 1ps
module manchester_serial_top (
    input  wire       clk,
    input  wire       rst,
    input  wire       valid,
    input  wire [7:0] data_in,
    output wire       serial_out,
    output wire       ready
  );

  wire [15:0] encoded_word;
  reg         load_shift;
  reg [7:0] local_data_in;

  manchester_encoder enc (
                       .data_in(local_data_in),
                       .manchester_out(encoded_word)
                     );

  shift_register_16_to_1 shift (
                           .clk(clk),
                           .rst(rst),
                           .load(load_shift),
                           .data_in(encoded_word),
                           .bit_out(serial_out),
                           .ready(ready)
                         );

  always @(posedge clk)
    begin
      if (rst)

        begin
          load_shift <= 0;
        end
      else
        begin
          local_data_in <= data_in;
          if (ready && valid ) begin
                load_shift <= 1; 
          end
          else begin
            load_shift <=0; 
          end


        end
    end
endmodule
