`timescale 1ns / 1ps
module tb_manchester_encoder;

  // Inputs
  reg aclk;
  reg aresetn;
  reg s_axis_tvalid;
  reg [7:0] s_axis_tdata;

  // Outputs
  wire s_axis_tready;
  wire serial_out;
  wire [7:0]data_out;
  wire decoder_valid;
  localparam CLK_PERIOD = 10;

  task send_axi_word;
    input [7:0] data;
    begin
      @(posedge aclk);
      @(posedge aclk);
      s_axis_tdata  <= data;
      s_axis_tvalid <= 1;
      wait (s_axis_tready);
      @(posedge aclk);
      @(posedge aclk);
      s_axis_tvalid <= 0;
    end
  endtask

  manchester_serial_top manch_top(
                          .aclk(aclk),
                          .aresetn(aresetn),
                          .s_axis_tvalid(s_axis_tvalid),
                          .s_axis_tdata(s_axis_tdata),
                          .serial_out(serial_out),
                          .s_axis_tready(s_axis_tready)
                        );
  manchester_decoder decode (
                       .clk(aclk),
                       .rst_n(aresetn),
                       .manchester_in(serial_out),
                       .sample_en(1'b1),
                       .data_out(data_out),
                       .data_valid(decoder_valid)
                     );
  // Clock generation: 100 MHz
  initial
    aclk = 0;
  always #(CLK_PERIOD/2) aclk = ~aclk;
  integer  i = 0;
  initial
    begin
      $dumpfile("tb_manchester_encoder.vcd");   // name of the waveform file
      $dumpvars(0, tb_manchester_encoder); // level 0 dumps all vars in module


      // Initial values
      s_axis_tdata   = 0;
      s_axis_tvalid  = 0;
      aresetn        = 0;
      repeat (3) @(posedge aclk);
      aresetn = 1;
      // Reset pulse
      send_axi_word(8'b11110000);
      send_axi_word(8'b00001111);
      send_axi_word(8'b10101010);

      repeat(50) @(posedge aclk);
      $finish;
    end
  always @(posedge aclk)
    begin
      if (decoder_valid)
        begin
          $display("OUTPUT: %02X", data_out);
        end
    end
endmodule
