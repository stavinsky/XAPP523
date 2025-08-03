`default_nettype none
;
`timescale 1ns / 1ps
;

module top_receiver_xilinix (
    input wire clk,
    input wire serial_in_p,
    input wire serial_in_n
);



  wire aresetn;
  wire clk_54;
  wire clk_54_90;
     wire clk_54_45;                
      wire clk_54_135;
      wire clk_200;

  clk_wiz_0 pll1 (
      .clk_in1(clk),
      .locked(aresetn),
      .clk_54(clk_54),
      .clk_54_90(clk_54_90),
      .clk_54_45(clk_54_45),
      .clk_54_135(clk_54_135),
      .clk_200(clk_200)
  );

  wire idelayctrl_ready;


  IDELAYCTRL idelayctrl_inst (
      .REFCLK(clk_200),
      .RST(!aresetn),
      .RDY(idelayctrl_ready)
  );
  
  wire din_delayed_0;
  wire serial_in;
  IBUFDS #(
      .DIFF_TERM   ("TRUE"),    // Differential Termination
      .IBUF_LOW_PWR("FALSE"),   // Low power="TRUE", Highest performance="FALSE" 
      .IOSTANDARD  ("DEFAULT")  // Specify the input I/O standard
  ) IBUFDS_inst (
      .O (serial_in),    // Buffer output
      .I (serial_in_p),  // Diff_p buffer input (connect directly to top-level port)
      .IB(serial_in_n)   // Diff_n buffer input (connect directly to top-level port)
  );

  IDELAYE2 #(
      .IDELAY_TYPE ("FIXED"),
      .IDELAY_VALUE(0),        // No delay
      .DELAY_SRC   ("IDATAIN")
  ) idelay0 (
      .C      (1'b0),          // Not used in FIXED mode
      .CE     (1'b0),
      .INC    (1'b0),
      .LD     (1'b0),
      .IDATAIN(serial_in),
      .DATAIN (1'b0),
      .DATAOUT(din_delayed_0)
  );
  wire din_delayed_1;
  IDELAYE2 #(
      .IDELAY_TYPE ("FIXED"),
      .IDELAY_VALUE(0),        // No delay
      .DELAY_SRC   ("IDATAIN")
  ) idelay1 (
      .C      (1'b0),          // Not used in FIXED mode
      .CE     (1'b0),
      .INC    (1'b0),
      .LD     (1'b0),
      .IDATAIN(serial_in),
      .DATAIN (1'b0),
      .DATAOUT(din_delayed_1)
  );

  wire [3:0] q_master_0;
  wire [3:0] q_master_90;

  // === ISERDES for 0° delay path ===
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
      .DDLY      (din_delayed_0),  // from IDELAYE2
      .CE1    (1'b1),
      .RST    (!aresetn),
      .CLK    (clk_54),          // 54 MHz
      .CLKB   (clk_54_90),
      .CLKDIV (),         // 13.5 MHz (optional, needed if you're shifting or FSM)
      .BITSLIP(1'b0),

      // Outputs — bits captured on each edge
      .Q1(q_master_0[3]),
      .Q2(q_master_0[2]),
      .Q3(q_master_0[1]),
      .Q4(q_master_0[0]),

      // Not used in this config

      .SHIFTIN1(1'b0),
      .SHIFTIN2(1'b0),
      .SHIFTOUT1(),
      .SHIFTOUT2()
  );
  // === ISERDES for 45° delay path ===
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
      .DDLY      (din_delayed_1),  // from IDELAYE2
      .CE1    (1'b1),
      .RST    (!aresetn),
      .CLK    (clk_54_45),           // 54 MHz
      .CLKB   (clk_54_135),
      .CLKDIV (),          // 13.5 MHz (optional, needed if you're shifting or FSM)
      .BITSLIP(1'b0),

      // Outputs — bits captured on each edge
      .Q1(q_master_90[3]),
      .Q2(q_master_90[2]),
      .Q3(q_master_90[1]),
      .Q4(q_master_90[0]),


      .SHIFTIN1(1'b0),
      .SHIFTIN2(1'b0),
      .SHIFTOUT1(),
      .SHIFTOUT2()
  );

  // Combine to full 8-sample window
  (* MARK_DEBUG="true" *)wire [7:0] sample_window = {q_master_0, q_master_90};

endmodule

