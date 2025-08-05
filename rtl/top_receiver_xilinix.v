`default_nettype none
;
`timescale 1ns / 1ps
;

module top_receiver_xilinix (
    input wire clk,
    input wire serial_in_p,
    input wire serial_in_n,
    output wire test_out_p,
    output wire test_out_n
);



  wire aresetn;
  wire clk_54;
  wire clk_54_90;
  wire clk_200;
  wire clk_fb;
  wire clk_div;
  wire clk_100;
  wire clk_dbg;
  wire clk_200_phase;
  clk_wiz_0 pll1 (
      .clk_in1(clk),
      .locked(aresetn),
      .clk_54(clk_54),
      .clk_54_90(clk_54_90),
      .clk_200(clk_200),
      .clk_200_phase(clk_200_phase),
      .clk_div(clk_div), //50mhz
      .clkfb_in(clk_fb), 
      .clk_100(clk_100),
      .clk_dbg(clk_dbg),//400mhz
    .clkfb_out(clk_fb)
  );
  wire clk_54_buf;
  wire clk_54_90_buf;
  
  BUFIO bufio1 (.I(clk_54), .O(clk_54_buf));
  BUFIO bufio2 (.I(clk_54_90), .O(clk_54_90_buf));

  wire idelayctrl_ready;

(* IODELAY_GROUP = "IO_DLY1" *)
  IDELAYCTRL idelayctrl_inst (
      .REFCLK(clk_200),
      .RST(!aresetn),
      .RDY(idelayctrl_ready)
  );
 (* MARK_DEBUG="true" *) wire serial_out_p;
    wire serial_out_n;

  IBUFDS_DIFF_OUT #(
   .DIFF_TERM("TRUE"),   // Differential Termination, "TRUE"/"FALSE"
   .IBUF_LOW_PWR("FALSE"), // Low power="TRUE", Highest performance="FALSE"
   .IOSTANDARD("TMDS_33") // Specify the input I/O standard
) IBUFDS_DIFF_OUT_inst (
   .O(serial_out_p),   // Buffer diff_p output
   .OB(serial_out_n), // Buffer diff_n output
   .I(serial_in_p),   // Diff_p buffer input (connect directly to top-level port)
   .IB(serial_in_n)  // Diff_n buffer input (connect directly to top-level port)
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
  (* IODELAY_GROUP = "IO_DLY1" *)
  IDELAYE2 #(
  .HIGH_PERFORMANCE_MODE("TRUE"),
      .IDELAY_TYPE ("FIXED"),
      .IDELAY_VALUE(0),         // No delay
      .DELAY_SRC   ("IDATAIN"),
      .PIPE_SEL("FALSE"), 
      .REFCLK_FREQUENCY(200.0),
      .SIGNAL_PATTERN("DATA")
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
  (* IODELAY_GROUP = "IO_DLY1" *)
  IDELAYE2 #(
    .HIGH_PERFORMANCE_MODE("TRUE"),
      .IDELAY_TYPE ("FIXED"),
      .IDELAY_VALUE(16),       
      .DELAY_SRC   ("IDATAIN"),
      .PIPE_SEL("FALSE"), 
      .REFCLK_FREQUENCY(200.0),
      .SIGNAL_PATTERN("DATA")
  ) idelay1 (
      .C      (1'b0),         
      .CE     (1'b0),
      .INC    (1'b0),
      .LD     (1'b0),
      .IDATAIN(serial_out_n),
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
      .IOBDELAY("NONE"),
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
      .DDLY   (din_delayed_0),  // from IDELAYE2
      .CE1    (1'b1),
      .RST    (!aresetn),
         .CLK    (clk_54_buf),      // 54 MHz
         .CLKB   (~clk_54_buf),
         .OCLK(clk_54_90_buf),
         .OCLKB(~clk_54_90_buf),
      .BITSLIP(1'b0),
//      .CLKDIV(clk_div),


      // Outputs — bits captured on each edge
      .Q1(q_master_0[3]),
      .Q2(q_master_0[2]),
      .Q3(q_master_0[1]),
      .Q4(q_master_0[0]),

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
         .IOBDELAY("NONE"),
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
         .DDLY   (din_delayed_1),  // from IDELAYE2
         .CE1    (1'b1),
         .RST    (!aresetn),
         .CLK    (clk_54_buf),      // 54 MHz
         .CLKB   (~clk_54_buf),
         .OCLK(clk_54_90_buf),
         .OCLKB(~clk_54_90_buf),
         .BITSLIP(1'b0),
//      .CLKDIV(clk_div),

         // Outputs — bits captured on each edge
         .Q1(q_master_90[3]),
         .Q2(q_master_90[2]),
         .Q3(q_master_90[1]),
         .Q4(q_master_90[0]),


         .SHIFTIN1 (1'b0),
         .SHIFTIN2 (1'b0),
         .SHIFTOUT1(),
         .SHIFTOUT2()
     );


    wire test_out = clk_200_phase;
//    reg test_out;

//    always @(posedge clk_div) begin 
//        if (!aresetn) begin 
//            test_out <= 0;
//        end
//        else begin
//            test_out <= !test_out;
//        end
//    end


    OBUFDS #(
   .IOSTANDARD("TMDS_33"), // Specify the output I/O standard
   .SLEW("FAST")           // Specify the output slew rate
) OBUFDS_inst (
   .O(test_out_p),     // Diff_p output (connect directly to top-level port)
   .OB(test_out_n),   // Diff_n output (connect directly to top-level port)
   .I(test_out)      // Buffer input
);





    
  // Combine to full 8-sample window
  (* MARK_DEBUG="true" *) wire [7:0] sample_window = {q_master_0, q_master_90};
  (* MARK_DEBUG="true" *)reg [7:0]test_reg;  
  always @(posedge clk_div) begin 
    test_reg <= sample_window;
  end

endmodule

