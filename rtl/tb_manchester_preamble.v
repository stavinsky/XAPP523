`timescale 1ns/1ps
// verilator lint_off INITIALDLY
module tb_manchester_preamble;

  // Parameters
  localparam DATA_WIDTH = 8;
  localparam CLK_PERIOD = 10;

  // DUT ports
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

  // Instantiate DUT
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

  // Clock generation
  initial
    aclk = 0;
  always #(CLK_PERIOD/2) aclk = ~aclk;
  integer  i = 0;
  // Stimulus task
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

  // Test sequence
  initial
    begin
      $dumpfile("tb_manchester_preamble.vcd");   // name of the waveform file
      $dumpvars(0, tb_manchester_preamble); // level 0 dumps all vars in module
      // Init
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

          @(posedge aclk); // Present data before this clock edge

          if (s_axis_tready)
            begin
              i = i + 1; // Advance to next word only if accepted
            end
          // else: hold the same data, try again next clock
        end
      s_axis_tvalid <= 0;
      for (i = 0; i < 32; i = i + 1)
        begin
          s_axis_tdata  <= i;
          s_axis_tvalid <= 1;
          s_axis_tlast  <= (i == 7) || (i == 15) || (i==23) || (i==31);

          // Wait for handshake
          if (s_axis_tready)
            begin
              @(posedge aclk);
            end
          else
            begin
              while (!s_axis_tready)
                @(posedge aclk)
                 ;
            end
          // @(posedge aclk);
        end
      s_axis_tvalid <= 0;
      repeat (10) @(posedge aclk);
      $finish;
    end

  // Output monitoring
  always @(posedge aclk)
    begin
      if (m_axis_tvalid && m_axis_tready)
        begin
          $display("OUTPUT: %02D%s", m_axis_tdata, m_axis_tlast ? " [TLAST]" : "");
        end
    end

endmodule
