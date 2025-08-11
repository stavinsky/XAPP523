module oversample (
    input wire clk_ref,
    input wire aresetn,
    input wire clk,  // has to be bufiio
    input wire clk_90,  // has to be bufio
    input wire serial_in_p,
    input wire serial_in_n,
    output wire [7:0] sample_window

);


  wire idelayctrl_ready;

  /* verilator lint_off MODMISSING */
  IDELAYCTRL idelayctrl_inst (
      .REFCLK(clk_ref),
      .RST(!aresetn),
      .RDY(idelayctrl_ready)
  );
  wire serial_out_p;
  wire serial_out_n;

  IBUFDS_DIFF_OUT #(
      .DIFF_TERM("FALSE"),  // Differential Termination, "TRUE"/"FALSE"
      .IBUF_LOW_PWR("FALSE"),  // Low power="TRUE", Highest performance="FALSE"
      .IOSTANDARD("TMDS_33")  // Specify the input I/O standard
  ) IBUFDS_DIFF_OUT_inst (
      .O (serial_out_p),  // Buffer diff_p output
      .OB(serial_out_n),  // Buffer diff_n output
      .I (serial_in_p),   // Diff_p buffer input (connect directly to top-level port)
      .IB(serial_in_n)    // Diff_n buffer input (connect directly to top-level port)
  );

  wire din_delayed_0;
  IDELAYE2 #(
      .IDELAY_TYPE ("FIXED"),
      .IDELAY_VALUE(1),         // No delay
      .DELAY_SRC   ("IDATAIN")
  ) idelay0 (
      .C      (1'b0),          // Not used in FIXED mode
      .CE     (1'b0),
      .INC    (1'b0),
      .LD     (1'b0),
      .IDATAIN(serial_out_p),
      .DATAIN (1'b0),
      .DATAOUT(din_delayed_0)
  );
  wire din_delayed_1;
  IDELAYE2 #(
      .IDELAY_TYPE ("FIXED"),
      .IDELAY_VALUE(18),        // No delay
      .DELAY_SRC   ("IDATAIN")
  ) idelay1 (
      .C      (1'b0),          // Not used in FIXED mode
      .CE     (1'b0),
      .INC    (1'b0),
      .LD     (1'b0),
      .IDATAIN(serial_out_n),
      .DATAIN (1'b0),
      .DATAOUT(din_delayed_1)
  );
  wire [4:0] q_master;
  wire [4:0] q_slave;

  ISERDESE2 #(
      .INTERFACE_TYPE("OVERSAMPLE"),
      .SERDES_MODE("MASTER"),
      .DATA_WIDTH(4),
      .DATA_RATE("DDR"),
      .OFB_USED("FALSE"),
      .IOBDELAY("IFD"),
      .NUM_CE(1),
      .DYN_CLKDIV_INV_EN("FALSE"),
      .DYN_CLK_INV_EN("FALSE"),
      .INIT_Q1(1'b0),
      .INIT_Q2(1'b0),
      .INIT_Q3(1'b0),
      .INIT_Q4(1'b0),
      .SRVAL_Q1(1'b0),
      .SRVAL_Q2(1'b0),
      .SRVAL_Q3(1'b0),
      .SRVAL_Q4(1'b0)
  ) iserdes_inst (
      .DDLY   (din_delayed_0),
      .CE1    (1'b1),
      .RST    (!aresetn),
      .CLK    (clk),
      .CLKB   (~clk),
      .OCLK   (clk_90),
      .OCLKB  (~clk_90),
      .BITSLIP(1'b0),


      .Q1(q_master[1]),
      .Q2(q_master[2]),
      .Q3(q_master[3]),
      .Q4(q_master[4]),

      .SHIFTIN1 (1'b0),
      .SHIFTIN2 (1'b0),
      .SHIFTOUT1(),
      .SHIFTOUT2()
  );
  ISERDESE2 #(
      .INTERFACE_TYPE("OVERSAMPLE"),
      .SERDES_MODE("MASTER"),
      .DATA_WIDTH(4),
      .DATA_RATE("DDR"),
      .OFB_USED("FALSE"),
      .IOBDELAY("IFD"),
      .NUM_CE(1),
      .DYN_CLKDIV_INV_EN("FALSE"),
      .DYN_CLK_INV_EN("FALSE"),
      .INIT_Q1(1'b0),
      .INIT_Q2(1'b0),
      .INIT_Q3(1'b0),
      .INIT_Q4(1'b0),
      .SRVAL_Q1(1'b0),
      .SRVAL_Q2(1'b0),
      .SRVAL_Q3(1'b0),
      .SRVAL_Q4(1'b0)
  ) iserdes_inst_90 (
      .DDLY   (din_delayed_1),
      .CE1    (1'b1),
      .RST    (!aresetn),
      .CLK    (clk),
      .CLKB   (~clk),
      .OCLK   (clk_90),
      .OCLKB  (~clk_90),
      .BITSLIP(1'b0),

      .Q1(q_slave[1]),
      .Q2(q_slave[2]),
      .Q3(q_slave[3]),
      .Q4(q_slave[4]),


      .SHIFTIN1 (1'b0),
      .SHIFTIN2 (1'b0),
      .SHIFTOUT1(),
      .SHIFTOUT2()
  );
  assign sample_window = {
    q_master[4],
    q_slave[4],
    q_master[2],
    q_slave[2],
    q_master[3],
    q_slave[3],
    q_master[1],
    q_slave[1]
  };
endmodule
