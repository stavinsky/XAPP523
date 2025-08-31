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
      .SLEW      ("SLOW")      // Specify the output slew rate
  ) OBUFDS_inst (
      .O (serial_out_diff_p),  // Diff_p output (connect directly to top-level port)
      .OB(serial_out_diff_n),  // Diff_n output (connect directly to top-level port)
      .I (serial_out)          // Buffer input
  );


  reg [7:0] data[0:8];
  initial begin
    data[0] = 8'hAA;
    data[1] = 8'hAA;
    data[2] = 8'hD5;
    data[3] = 8'hAA;
    data[4] = 8'hBB;
    data[5] = 8'hCC;
    data[6] = 8'hDD;
    data[7] = 8'hEE;
    data[8] = 8'hFF;
  end
  (* MARK_DEBUG="TRUE" *) reg [3:0] cnt;
  (* MARK_DEBUG="TRUE" *) reg [7:0] man_in;
  (* MARK_DEBUG="TRUE" *) wire [15:0] man_out;
  (* MARK_DEBUG="TRUE" *) reg second_word;
  wire [7:0] man_hi = man_out[15:8];
  wire [7:0] man_lo = man_out[7:0];
  (* MARK_DEBUG="TRUE" *) reg [7:0] data_out;
  reg [7:0] man_in_r;

  manchester_encoder me_1 (
      .data_in(man_in_r),
      .manchester_out(man_out)
  );

  always @(posedge clk_div_r) begin
    if (!aresetn) begin
      cnt <= 0;
      second_word <= 0;
    end else begin
      second_word <= ~second_word;
      if (second_word) begin
        if (cnt == 8) begin
          cnt <= 0;
        end else begin
          cnt <= cnt + 1;
        end
      end
    end
  end
  always @(posedge clk_div_r) begin
    man_in   <= data[cnt];
    man_in_r <= man_in;
    data_out <= (second_word) ? man_lo : man_hi;
  end


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
      .D1(data_out[7]),
      .D2(data_out[6]),
      .D3(data_out[5]),
      .D4(data_out[4]),
      .D5(data_out[3]),
      .D6(data_out[2]),
      .D7(data_out[1]),
      .D8(data_out[0]),

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
