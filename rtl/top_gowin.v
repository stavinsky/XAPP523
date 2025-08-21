module top_gowin (
    input       sys_clk,
    input       sys_rst_n,
    output wire serial_out_diff_p,
    output wire serial_out_diff_n,
    output wire test_clk

);
  wire clk108;
  wire aresetn;
  wire in_clk;


  Gowin_rPLL your_instance_name (
      .reset (sys_rst_n),
      .clkout(clk108),
      .lock  (aresetn),
      .clkin (sys_clk)
  );

  wire serial_out;
    assign serial_out = 1;
  TLVDS_OBUF tmds_bufds (
      .I (serial_out),
      .O (serial_out_diff_p),
      .OB(serial_out_diff_n)
  );



  reg [5:0] cnt;
  reg [55:0] data;
  reg data_bit;
  ODDR oddr1 (
      .CLK(clk108),
      .D0 (~data_bit),
      .D1 (data_bit),
      .Q0 (test_clk),
      .TX (1'b1)
  );
  always @(posedge clk108) begin
    if (!aresetn) begin
      cnt <= 0;
      data <= 56'hAAAAD5AABBCCDD;
      data_bit <= 0;
    end else begin
      data_bit <= data[55-cnt];
      cnt <= (cnt == 55) ? 0 : cnt + 1'b1;

    end
  end



endmodule
