`timescale 1ns/1ps
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
          $display("OUTPUT: %02X%s", m_axis_tdata, m_axis_tlast ? " [TLAST]" : "");
        end
    end

endmodule
