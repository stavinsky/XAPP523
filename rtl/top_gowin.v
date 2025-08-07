module top_gowin (
    input             sys_clk,            // clk input
    input             sys_rst_n,          // reset input
    output reg  [5:0] led,                // 6 LEDS pin
    output wire       serial_out_diff_p,
    output wire       serial_out_diff_n,
    output wire test_clk

);
  wire clk108;
  wire aresetn;
//    Gowin_rPLL your_instance_name(
//        .clkout(clk108), //output clkout
//        .lock(aresetn), //output lock
//        .clkin(sys_clk) //input clkin
//    );
assign test_clk = serial_out;
wire in_clk;
//OSC #(.DEVICE("GW1NR-9C"),.FREQ_DIV(4))osc1 (.OSCOUT(in_clk));


    Gowin_rPLL your_instance_name(
        .reset(sys_rst_n),
        .clkout(clk108), //output clkout
        .lock(aresetn), //output lock
        .clkin(sys_clk) //input clkin
    );
//rPLL #( // For GW1NR-9C C6/I5 (Tang Nano 9K proto dev board)
//  .FCLKIN("27"),
//  .IDIV_SEL(4), // -> PFD = 5.4 MHz (range: 3-400 MHz)
//  .FBDIV_SEL(36), // -> CLKOUT = 199.8 MHz (range: 3.125-600 MHz)
//  .ODIV_SEL(4) // -> VCO = 799.2 MHz (range: 400-1200 MHz)
//) pll (.CLKOUTP(), .CLKOUTD(), .CLKOUTD3(), .RESET(1'b0), .RESET_P(1'b0), .CLKFB(1'b0), .FBDSEL(6'b0), .IDSEL(6'b0), .ODSEL(6'b0), .PSDA(4'b0), .DUTYDA(4'b0), .FDLY(4'b0),
//  .CLKIN(sys_clk), // 50 MHz
//  .CLKOUT(clk108), // 400 MHz
//  .LOCK(aresetn)
//);
//  rPLL #(  // For GW1NR-9C C6/I5 (Tang Nano 9K proto dev board)
//      .FCLKIN("27"),
//      .IDIV_SEL(0),  // -> PFD = 27 MHz (range: 3-400 MHz)
//      .FBDIV_SEL(1),  // -> CLKOUT = 54 MHz (range: 3.125-600 MHz)
//      .ODIV_SEL(8)  // -> VCO = 432 MHz (range: 400-1200 MHz)
//  ) pll (
//      .CLKOUTP(),
//      .CLKOUTD(),
//      .CLKOUTD3(),
//      .RESET(1'b0),
//      .RESET_P(1'b0),
//      .CLKFB(1'b0),
//      .FBDSEL(6'b0),
//      .IDSEL(6'b0),
//      .ODSEL(6'b0),
//      .PSDA(4'b0),
//      .DUTYDA(4'b0),
//      .FDLY(4'b0),
//      .CLKIN(sys_clk),  // 27 MHz
//      .CLKOUT(clk108),  // 54 MHz
//      .LOCK(aresetn)
//  );

  wire serial_out;
  TLVDS_OBUF tmds_bufds (
      .I (serial_out),
      .O (serial_out_diff_p),
      .OB(serial_out_diff_n)
  );

  //   power_on_reset por (
  //       .clk(clk),
  //       .reset_n(aresetn)
  //   );
  manchester_sender cnt_send (
      .aclk(clk108),
      .serial_out(serial_out),
      .aresetn(aresetn)
  );





  //// LED example
  reg [23:0] counter;

  always @(posedge sys_clk or negedge aresetn) begin
    if (!aresetn) counter <= 24'd0;
    else if (counter < 24'd1349_9999)  // 0.5s delay
      counter <= counter + 1'd1;
    else counter <= 24'd0;
  end

  always @(posedge sys_clk or negedge aresetn) begin
    if (!aresetn) led <= 6'b111110;
    else if (counter == 24'd1349_9999)  // 0.5s delay
      led[5:0] <= {led[4:0], led[5]};
    else led <= led;
  end



endmodule
