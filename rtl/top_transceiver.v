module top (
    input sys_clk,
    output wire serial_out_diff_p,
    output wire serial_out_diff_n
);



  wire clk_fast;  //400mhz
  wire clk_div;
  wire aresetn;
  wire clk_fb;

  tx_clk pll1_inst (
      .clkfb_in(clk_fb),
      .clk_out1(clk_fast),  //400 mhz (raw)
      .clk_out2(clk_div),  //100 mhz (raw)
      .clkfb_out(clk_fb),
      .locked(aresetn),
      .clk_in1(sys_clk)
  );

  wire clk_fast_io;
  BUFIO bufio1 (
      .I(clk_fast),
      .O(clk_fast_io)
  );
  wire clk_div_r;
  BUFR #(
      .BUFR_DIVIDE("BYPASS"),  // Values: "BYPASS, 1, 2, 3, 4, 5, 6, 7, 8"
      .SIM_DEVICE ("7SERIES")  // Must be set to "7SERIES"
  ) BUFR_inst (
      .O(clk_div_r),  // 1-bit output: Clock output port
      .CE(1'b1),  // 1-bit input: Active high, clock enable (Divided modes only)
      .CLR(1'b0),  // 1-bit input: Active high, asynchronous clear (Divided modes only)
      .I(clk_div)  // 1-bit input: Clock buffer input driven by an IBUF, MMCM or local interconnect
  );
  wire serial_out;
  OBUFDS #(
      .IOSTANDARD("TMDS_33"),  // Specify the output I/O standard
      .SLEW      ("FAST")      // Specify the output slew rate
  ) OBUFDS_inst (
      .O (serial_out_diff_p),  // Diff_p output (connect directly to top-level port)
      .OB(serial_out_diff_n),  // Diff_n output (connect directly to top-level port)
      .I (serial_out)          // Buffer input
  );

  wire [7:0] pattern_tdata;
  wire pattern_tvalid;
  wire pattern_tready;
  axis_pattern_generator pattern_gen (
      .aclk(clk_div_r),
      .aresetn(aresetn),
      .m_axis_tdata(pattern_tdata),
      .m_axis_tvalid(pattern_tvalid),
      .m_axis_tready(pattern_tready)
  );

  (* MARK_DEBUG="TRUE" *) wire [7:0] encoder_tdata;
  wire encoder_tvalid;
  wire encoder_tready = 1;
  axis_manchester_encoder encoder (
      .aclk(clk_div_r),
      .aresetn(aresetn),
      .s_axis_tdata(pattern_tdata),
      .s_axis_tvalid(pattern_tvalid),
      .s_axis_tready(pattern_tready),

      .m_axis_tdata (encoder_tdata),
      .m_axis_tvalid(encoder_tvalid),
      .m_axis_tready(encoder_tready)
  );



  OSERDESE2 #(
      .DATA_RATE_OQ  ("DDR"),
      .DATA_RATE_TQ  ("DDR"),
      .DATA_WIDTH    (8),
      .SERDES_MODE   ("MASTER"),
      .TRISTATE_WIDTH(1),
      .TBYTE_CTL     ("FALSE"),
      .TBYTE_SRC     ("FALSE")
  ) u_oserdes (
      .CLK   (clk_fast_io),
      .CLKDIV(clk_div_r),

      // Data: D1 is the FIRST bit to appear on the line after (re)load
      .D1(encoder_tdata[7]),
      .D2(encoder_tdata[6]),
      .D3(encoder_tdata[5]),
      .D4(encoder_tdata[4]),
      .D5(encoder_tdata[3]),
      .D6(encoder_tdata[2]),
      .D7(encoder_tdata[1]),
      .D8(encoder_tdata[0]),

      // Control
      .OCE(1'b1),  // 1=enable shift
      .RST(!aresetn),  // resets internal pipeline

      // Outputs
      .OQ(serial_out),
      .TQ(),  // unused (no tri-state)

      // Tie-offs for no tri-state usage
      .TCE(1'b0),
      .T1 (1'b0),
      .T2 (1'b0),
      .T3 (1'b0),
      .T4 (1'b0),

      // Unused cascade/bytes
      .SHIFTIN1 (1'b0),
      .SHIFTIN2 (1'b0),
      .SHIFTOUT1(),
      .SHIFTOUT2(),
      .OFB      (),
      .TFB      (),
      .TBYTEIN  (1'b0),
      .TBYTEOUT ()
  );
endmodule
