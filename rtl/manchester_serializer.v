`timescale 1ns / 1ps
module manchester_serializer (
    input  wire       aclk,
    input  wire       aresetn,
    input  wire [7:0] s_axis_tdata,
    input  wire       s_axis_tvalid,
    output wire       s_axis_tready,
    output wire       serial_out
);

  wire [15:0] encoded_word;
  reg         load_shift;
  reg  [ 7:0] local_data_in;

  manchester_encoder enc (
      .data_in(local_data_in),
      .manchester_out(encoded_word)
  );
  wire shift_ready;

  shift_register_16_to_1 shift (
      .clk(aclk),
      .rst(!aresetn),
      .load(load_shift),
      .data_in(encoded_word),
      .bit_out(serial_out),
      .ready(shift_ready)
  );

  reg holding;
  assign s_axis_tready = (!holding);
  always @(posedge aclk) begin
    if (!aresetn) begin
      load_shift <= 0;
      holding <= 0;
    end else begin
      load_shift <= 0;
      if (s_axis_tvalid && !holding) begin
        holding <= 1;
        local_data_in <= s_axis_tdata;

      end

      if (holding && shift_ready) begin
        load_shift <= 1;
        holding <= 0;
      end

    end
  end
endmodule
