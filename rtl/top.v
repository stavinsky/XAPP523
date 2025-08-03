module top (
    input clk,
    //  input aresetn,
    output wire serial_out_diff_p,
    output wire serial_out_diff_n,
    input wire serial_in_p,
    input wire serial_in_n
);

  (* MARK_DEBUG="true" *) wire serial_out;
  OBUFDS #(
      .IOSTANDARD("DEFAULT"),  // Specify the output I/O standard
      .SLEW      ("FAST")      // Specify the output slew rate
  ) OBUFDS_inst (
      .O (serial_out_diff_p),  // Diff_p output (connect directly to top-level port)
      .OB(serial_out_diff_n),  // Diff_n output (connect directly to top-level port)
      .I (serial_out)          // Buffer input
  );
  (* MARK_DEBUG="true" *) wire serial_in;
  IBUFDS #(
      .DIFF_TERM   ("TRUE"),    // Differential Termination
      .IBUF_LOW_PWR("FALSE"),   // Low power="TRUE", Highest performance="FALSE" 
      .IOSTANDARD  ("DEFAULT")  // Specify the input I/O standard
  ) IBUFDS_inst (
      .O (serial_in),    // Buffer output
      .I (serial_in_p),  // Diff_p buffer input (connect directly to top-level port)
      .IB(serial_in_n)   // Diff_n buffer input (connect directly to top-level port)
  );
  wire clk_200;
  wire clk_50;
  wire clk_50_90;
  wire clk_300;
  wire clk_600;
  clk_wiz_0(
      // Clock out ports
      .clk_200(clk_200),
      .clk_50(clk_50),
      .clk_50_90(clk_50_90),
      .clk_300(clk_300),
      .clk_out5(clk_600),
      // Status and control signals
      .reset(1'b0),
      .locked(aresetn),
      // Clock in ports
      .clk_in1(clk)
  );

  wire aresetn;
  //   power_on_reset por (
  //       .clk(clk),
  //       .reset_n(aresetn)
  //   );
  counter_sender cnt_send (
      .clk(clk_200),
      .aresetn(aresetn),
      .serial_out(serial_out)
  );
  wire [7:0] decoder1_m_axis_tdata;
  wire decoder1_m_axis_tvalid;
  wire decoder1_m_axis_tready;
  manchester_decoder #(
      .FRAME_SIZE(8)
  ) decoder1 (
      .aclk(clk_200),
      .aresetn(aresetn),
      .manchester_in(serial_out),
      .m_axis_tdata(decoder1_m_axis_tdata),
      .m_axis_tvalid(decoder1_m_axis_tvalid),
      .m_axis_tready(1)
  );
endmodule
