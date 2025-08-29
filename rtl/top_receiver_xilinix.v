
`timescale 1ns / 1ps

module top_receiver_xilinix (
    input wire clk,
    input wire serial_in_p,
    input wire serial_in_n
);

  wire aresetn;
  wire clk_54;
  wire clk_54_90;
  wire clk_200;
  wire clk_fb;
  wire clk_fast;
  wire clk_div;
  wire clk_g;
  BUFG bufg1 (
      .I(clk),
      .O(clk_g)
  );
  clk_wiz_0_1 pll1 (
      .clk_in1(clk_g),
      .locked(aresetn),
      .clk_0(clk_54),
      .clk_90(clk_54_90),
      .clk_200(clk_200),
      .clkfb_in(clk_fb),
      .clkfb_out(clk_fb),
      .clk_fast(clk_fast),
      .clk_div(clk_div)
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
  wire [7:0] sample_window;
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
  wire [2:0] out;
  wire [1:0] num_bits;

  data_recovery_unit dru (
      .sample_window(sample_window),
      .clk(clk_fast),
      .aresetn(aresetn),
      .out(out),
      .num_bits(num_bits)
  );
  wire [1:0] decoded_bits;
  wire [1:0] num_decoded_bits;
  wire [7:0] decoded_byte;
  wire byte_valid;
  manchester_decoder2 decoder (
      .aclk(clk_fast),
      .aresetn(aresetn),
      .bits(out),
      .num_bits(num_bits),
      .num_decoded_bits(num_decoded_bits),
      .decoded_bits(decoded_bits),
      .decoded_byte(decoded_byte),
      .byte_valid(byte_valid)
  );
  reg [7:0] data_byte;
  reg [1:0] delay_counter;
  reg byte_valid_latch;

  always @(posedge clk_fast) begin
    if (!aresetn) begin
      delay_counter <= 0;
    end else begin
      data_byte <= data_byte;
      if (byte_valid) begin
        delay_counter <= 0;
        byte_valid_latch <= 1'b1;
        data_byte <= decoded_byte;
      end else if (delay_counter == 3) begin
        byte_valid_latch <= 1'b0;
      end else begin
        delay_counter <= delay_counter + 1;
      end
    end
  end
  (* MARK_DEBUG="TRUE" *) reg data_out_valid;
  (* MARK_DEBUG="TRUE" *) reg [7:0] data_out;
  always @(posedge clk_div) begin
    data_out_valid <= 1'b0;
    if (byte_valid_latch) begin
      data_out_valid <= 1'b1;
      data_out <= data_byte;
    end
  end


endmodule

