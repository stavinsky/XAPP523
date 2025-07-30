`timescale 1ns / 1ps
`include "assert_utils.vh"
// verilator lint_off INITIALDLY
module tb_manchester_serializer;

  // Inputs
  reg aclk;
  reg aresetn;
  reg s_axis_tvalid;
  reg [7:0] s_axis_tdata;

  // Outputs
  wire s_axis_tready;
  wire serial_out;
  wire [7:0]m_axis_tdata;
  wire m_axis_tvalid;
  reg m_axis_tready;
  localparam CLK_PERIOD = 10;
  reg [7:0] expected_data [0:10];
  integer  verification_counter;

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

  manchester_serializer manch_top(
                          .aclk(aclk),
                          .aresetn(aresetn),
                          .s_axis_tvalid(s_axis_tvalid),
                          .s_axis_tdata(s_axis_tdata),
                          .serial_out(serial_out),
                          .s_axis_tready(s_axis_tready)
                        );
  manchester_decoder #(.FRAME_SIZE(4)) decoder (
                       .aclk(aclk),
                       .aresetn(aresetn),
                       .manchester_in(serial_out),
                       .m_axis_tdata(m_axis_tdata),
                       .m_axis_tvalid(m_axis_tvalid),
                       .m_axis_tready(m_axis_tready)
                     );
  initial
    aclk = 0;
  always #(CLK_PERIOD/2) aclk = ~aclk;
  initial
    begin
      $dumpfile("tb_manchester_serializer.vcd");
      $dumpvars(0, tb_manchester_serializer);
      expected_data[0] =8'b11110000;
      expected_data[1] =8'b00001111;
      expected_data[2] =8'b10101010;
      expected_data[3] =8'b10101010;

      expected_data[4] =8'b11110000;
      expected_data[5] =8'b00001111;
      expected_data[6] =8'b10101010;
      expected_data[7] =8'b10101010;

      verification_counter = 0;
      m_axis_tready = 1;



      s_axis_tdata   = 0;
      s_axis_tvalid  = 0;
      aresetn        = 0;
      repeat (3) @(posedge aclk);
      aresetn = 1;
      /// transaction 1
      send_axi_word(8'hAA);
      send_axi_word(8'hAA);
      send_axi_word(8'hD5);

      send_axi_word(8'b11110000);
      send_axi_word(8'b00001111);
      send_axi_word(8'b10101010);
      send_axi_word(8'b10101010);

      /// transaction 2
      send_axi_word(8'hAA);
      send_axi_word(8'hAA);
      send_axi_word(8'hD5);

      send_axi_word(8'b11110000);
      send_axi_word(8'b00001111);
      send_axi_word(8'b10101010);
      send_axi_word(8'b10101010);


      repeat(50) @(posedge aclk);
      $finish;
    end
  always @(posedge aclk)
    begin
      if (m_axis_tvalid === 1'b1 )
        begin

          `ASSERT_EQ(m_axis_tdata, expected_data[verification_counter],"");
          verification_counter <= verification_counter + 1;
        end
    end
endmodule
