`default_nettype none
;
`timescale 1ns / 1ps
;

module top_receiver_xilinix (
    input  wire clk,
    input  wire serial_in_p,
    input  wire serial_in_n,
    output wire test_out
//    output wire test_out_p,
//    output wire test_out_n
);



  wire aresetn;
  wire clk_54;
  wire clk_54_90;
  wire clk_200;
  wire clk_fb;
  wire clk_div;
  wire clk_dbg;
  wire clk_100;
  wire clk_serial_out;
  clk_wiz_0_1 pll1 (
      .clk_in1(clk),
      .locked(aresetn),
      .clk_0(clk_54),
      .clk_90(clk_54_90),
      .clk_200(clk_200),
      .clk_div(clk_div),
      .clk_dbg(clk_dbg),
      .clkfb_in(clk_fb),
      .clkfb_out(clk_fb),
      .clk_100(clk_100),
      .serial_out_clk(clk_serial_out)
  );
  wire clk_54_buf;
  wire clk_54_90_buf;

  BUFIO bufio1 (
      .I(clk_54),
      .O(clk_54_buf)
  );
  BUFIO bufio2 (
      .I(clk_54_90),
      .O(clk_54_90_buf)
  );

  wire idelayctrl_ready;


  IDELAYCTRL idelayctrl_inst (
      .REFCLK(clk_200),
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

  //  (* MARK_DEBUG="true" *)wire serial_in;
  //  IBUFDS #(
  //      .DIFF_TERM   ("TRUE"),    // Differential Termination
  //      .IBUF_LOW_PWR("FALSE"),   // Low power="TRUE", Highest performance="FALSE"
  //      .IOSTANDARD  ("DEFAULT")  // Specify the input I/O standard
  //  ) IBUFDS_inst (
  //      .O (serial_in),    // Buffer output
  //      .I (serial_in_p),  // Diff_p buffer input (connect directly to top-level port)
  //      .IB(serial_in_n)   // Diff_n buffer input (connect directly to top-level port)
  //  );



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
      .IDELAY_VALUE(18),         // No delay
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
      .DDLY   (din_delayed_0),   // from IDELAYE2
      .CE1    (1'b1),
      .RST    (!aresetn),
      .CLK    (clk_54_buf),      // 54 MHz
      .CLKB   (~clk_54_buf),
      .OCLK   (clk_54_90_buf),
      .OCLKB  (~clk_54_90_buf),
      .BITSLIP(1'b0),
      //      .CLKDIV(clk_div),
      //      .CLKDIVP(1'b0),

      // Outputs — bits captured on each edge
      .Q1(q_master[1]),
      .Q2(q_master[2]),
      .Q3(q_master[3]),
      .Q4(q_master[4]),

      // Not used in this config

      .SHIFTIN1 (1'b0),
      .SHIFTIN2 (1'b0),
      .SHIFTOUT1(),
      .SHIFTOUT2()
  );
  //   === ISERDES for 45° delay path ===
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
      .DDLY   (din_delayed_1),   // from IDELAYE2
      .CE1    (1'b1),
      .RST    (!aresetn),
      .CLK    (clk_54_buf),      // 54 MHz
      .CLKB   (~clk_54_buf),
      .OCLK   (clk_54_90_buf),
      .OCLKB  (~clk_54_90_buf),
      .BITSLIP(1'b0),
      //      .CLKDIV(clk_div),

      // Outputs — bits captured on each edge
      .Q1(q_slave[1]),
      .Q2(q_slave[2]),
      .Q3(q_slave[3]),
      .Q4(q_slave[4]),


      .SHIFTIN1 (1'b0),
      .SHIFTIN2 (1'b0),
      .SHIFTOUT1(),
      .SHIFTOUT2()
  );

  //  // Combine to full 8-sample window
  (* MARK_DEBUG="true" *) wire [7:0] sample_window = {q_master[4], q_slave[4], q_master[2], q_slave[2], q_master[3], q_slave[3], q_master[1], q_slave[1] } ;
  
  
  reg [7:0] sw;
  always @(posedge clk_100) begin
    sw <= sample_window;              
  end
  reg q7_prev;
  always @(posedge clk_100) begin
    q7_prev <= sw[7];
  end
  
  (* MARK_DEBUG="true" *)reg [3:0] E;

//  end
  always @(*) begin 
    E[0] = (sw[1] ^ ~sw[0]) | (sw[5] ^ ~sw[4]);
    E[1] = (sw[1] ^ ~sw[2]) | (sw[5] ^ ~sw[6]);
    E[2] = (sw[2] ^ ~sw[3]) | (sw[7] ^ ~sw[6]);
    E[3] = (sw[4] ^ ~sw[3]) | (sw[0] ^ ~q7_prev);
  end


//  (* MARK_DEBUG="true" *)wire test_out;


//reg [4:0] cnt;
//reg [31:0] data;
//reg data_bit;
//assign test_out = clk_serial_out ^ data_bit;
assign test_out = clk_serial_out;
// always @(posedge clk_serial_out) begin 
//    if(!aresetn) begin 
//        cnt <= 0;
//        data <= 32'hAA550FF0;
//        data_bit <= 0;
//    end
//    else begin 
//        data_bit <= data[cnt];
//        cnt <= cnt+1'b1;
//    end
//end


//  (* MARK_DEBUG="true" *) wire test_out;
//  counter_sender cnt (
//      .clk(clk_dbg),
//      .aresetn(aresetn),
//      .serial_out(test_out)
//  );

  (* MARK_DEBUG="true" *) reg [7:0] test_shift;
  always @(posedge clk_100) begin
    test_shift <= {test_shift[5:0], sample_window[3],sample_window[2]};
  end

  (* MARK_DEBUG="true" *) reg [7:0] test_100;
  always @(posedge clk_100) begin
    test_100 <= sample_window;
  end
//  OBUFDS #(
//      .IOSTANDARD("TMDS_33"),
//      .SLEW("FAST")
//  ) obufds (
//      .O (test_out_p),
//      .OB(test_out_n),
//      .I (test_out)
//  );


endmodule

