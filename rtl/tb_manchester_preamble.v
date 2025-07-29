`timescale 1ns/1ps
`include "assert_utils.vh"

// verilator lint_off INITIALDLY
module tb_manchester_preamble;

  localparam DATA_WIDTH = 8;
  localparam CLK_PERIOD = 10;

  reg                       aclk;
  reg                       aresetn;
  reg  [DATA_WIDTH-1:0]     s_axis_tdata;
  reg                       s_axis_tvalid;
  wire                      s_axis_tready;
  reg                       s_axis_tlast;

  wire [DATA_WIDTH-1:0]     m_axis_tdata;
  wire                      m_axis_tvalid;
  reg                       m_axis_tready;
  wire                      m_axis_tlast;
  reg [DATA_WIDTH-1:0]expected_data[0:51];
  integer verification_counter;

  manchester_preamble #(
                        .DATA_WIDTH(DATA_WIDTH)
                      ) dut (
                        .aclk           (aclk),
                        .aresetn        (aresetn),
                        .s_axis_tdata   (s_axis_tdata),
                        .s_axis_tvalid  (s_axis_tvalid),
                        .s_axis_tready  (s_axis_tready),
                        .s_axis_tlast   (s_axis_tlast),
                        .m_axis_tdata   (m_axis_tdata),
                        .m_axis_tvalid  (m_axis_tvalid),
                        .m_axis_tready  (m_axis_tready),
                        .m_axis_tlast   (m_axis_tlast)
                      );

  initial
    aclk = 0;
  always #(CLK_PERIOD/2) aclk = ~aclk;
  integer  i = 0;
  task send_axi_word;
    input [7:0] data;
    input       last;
    begin
      @(posedge aclk);
      s_axis_tdata  <= data;
      s_axis_tvalid <= 1;
      s_axis_tlast  <= last;
      wait (s_axis_tready);
      @(posedge aclk);
      s_axis_tvalid <= 0;
      s_axis_tlast  <= 0;
    end
  endtask

  initial
    begin
      $dumpfile("tb_manchester_preamble.vcd");
      $dumpvars(0, tb_manchester_preamble);
      s_axis_tdata   = 0;
      s_axis_tvalid  = 0;
      s_axis_tlast   = 0;
      m_axis_tready  = 1;
      aresetn        = 0;
      repeat (3) @(posedge aclk);
      aresetn = 1;

      send_axi_word(8'h11, 0);
      send_axi_word(8'h22, 0);
      send_axi_word(8'h33, 0);
      send_axi_word(8'h44, 0);
      send_axi_word(8'h55, 1);
      @(posedge aclk);
      @(posedge aclk);

      s_axis_tvalid <= 1;
      while (i < 32)
        begin
          s_axis_tdata <= i[7:0];
          s_axis_tlast <= (i == 7) || (i == 15) || (i == 23) || (i == 31);

          @(posedge aclk);

          if (s_axis_tready)
            begin
              i = i + 1;
            end
        end
      s_axis_tvalid <= 0;

      repeat (10) @(posedge aclk);
      $finish;
    end

  always @(posedge aclk)
    begin
      if (m_axis_tvalid && m_axis_tready)
        begin
          `ASSERT_EQ(expected_data[verification_counter], m_axis_tdata, $sformatf("iteration %D", verification_counter));
          verification_counter <= verification_counter + 1;
          if(
            verification_counter == 7
            || verification_counter == 18
            || verification_counter == 29
            || verification_counter == 40
            || verification_counter == 51
          )
            begin
              `ASSERT_EQ(1, m_axis_tlast, "tlast assertion");
            end
          // $display("OUTPUT: %02X%s", m_axis_tdata, m_axis_tlast ? " [TLAST]" : "");
        end
    end

  initial
    begin
      verification_counter =0;
      expected_data[0]=8'haa;
      expected_data[1]=8'haa;
      expected_data[2]=8'hd5;
      expected_data[3]=8'h11;
      expected_data[4]=8'h22;
      expected_data[5]=8'h33;
      expected_data[6]=8'h44;
      expected_data[7]=8'h55;// [TLAST]
      expected_data[8]=8'haa;
      expected_data[9]=8'haa;
      expected_data[10]=8'hd5;
      expected_data[11]=8'h00;
      expected_data[12]=8'h01;
      expected_data[13]=8'h02;
      expected_data[14]=8'h03;
      expected_data[15]=8'h04;
      expected_data[16]=8'h05;
      expected_data[17]=8'h06;
      expected_data[18]=8'h07;// [TLAST]
      expected_data[19]=8'haa;
      expected_data[20]=8'haa;
      expected_data[21]=8'hd5;
      expected_data[22]=8'h08;
      expected_data[23]=8'h09;
      expected_data[24]=8'h0a;
      expected_data[25]=8'h0b;
      expected_data[26]=8'h0c;
      expected_data[27]=8'h0d;
      expected_data[28]=8'h0e;
      expected_data[29]=8'h0f;// [TLAST]
      expected_data[30]=8'haa;
      expected_data[31]=8'haa;
      expected_data[32]=8'hd5;
      expected_data[33]=8'h10;
      expected_data[34]=8'h11;
      expected_data[35]=8'h12;
      expected_data[36]=8'h13;
      expected_data[37]=8'h14;
      expected_data[38]=8'h15;
      expected_data[39]=8'h16;
      expected_data[40]=8'h17;// [TLAST]
      expected_data[41]=8'haa;
      expected_data[42]=8'haa;
      expected_data[43]=8'hd5;
      expected_data[44]=8'h18;
      expected_data[45]=8'h19;
      expected_data[46]=8'h1a;
      expected_data[47]=8'h1b;
      expected_data[48]=8'h1c;
      expected_data[49]=8'h1d;
      expected_data[50]=8'h1e;
      expected_data[51]=8'h1f;// [TLAST]
    end
endmodule
