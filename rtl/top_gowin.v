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



  // reg [5:0] cnt;
  // reg [55:0] data;
  // reg data_bit;
  // ODDR oddr1 (
  //     .CLK(clk108),
  //     .D0 (~data_bit),
  //     .D1 (data_bit),
  //     .Q0 (test_clk),
  //     .TX (1'b1)
  // );
  // always @(posedge clk108) begin
  //   if (!aresetn) begin
  //     cnt <= 0;
  //     data <= 56'hAAAAD5AABBCCEE;
  //     data_bit <= 0;
  //   end else begin
  //     data_bit <= data[55-cnt];
  //     cnt <= (cnt == 55) ? 0 : cnt + 1'b1;

  //   end
  // end
  reg [1:0] ce_div;
  always @(posedge clk108 or negedge aresetn) begin
    if (!aresetn) ce_div <= 2'b00;
    else ce_div <= ce_div + 2'd1;
  end

  wire pclk_ce_clk = (ce_div == 2'b00);
  wire pclk_ce;
   BUFG bufg1 (.I(pclk_ce_clk), .O(pclk_ce));

  reg [7:0] data[0:6];
  reg [2:0] cnt;
  reg [7:0] data_8;
  wire [15:0] man_out;
  wire [7:0] data_out = (second_word) ? man_out[15:8] : man_out[7:0];
  reg second_word;
  manchester_encoder me_1 (
      .data_in(data_8),
      .manchester_out(man_out)
  );
  initial begin
    data[0] = 8'hAA;
    data[1] = 8'hAA;
    data[2] = 8'hD5;
    data[3] = 8'hAA;
    data[4] = 8'hBB;
    data[5] = 8'hCC;
    data[6] = 8'hFF;
  end


  always @(posedge pclk_ce) begin
    if (!aresetn) begin
      cnt <= 0;
      second_word <= 0;
    end else begin
      cnt <= (cnt == 6) ? 0 : cnt + 1'b1;
      data_8 <= data[cnt];
      if (cnt == 6) begin
        second_word <= ~second_word;
      end
    end
  end

  OSER8 ser8_1 (
      .Q0(test_clk),
      .Q1(),
      .D0(data_out[0]),
      .D1(data_out[1]),
      .D2(data_out[2]),
      .D3(data_out[3]),
      .D4(data_out[4]),
      .D5(data_out[5]),
      .D6(data_out[6]),
      .D7(data_out[7]),
      .TX0(1'b1),
      .TX1(1'b1),
      .TX2(1'b1),
      .TX3(1'b1),
      .PCLK(pclk_ce),
      .FCLK(clk108),
      .RESET(~aresetn)
  );



endmodule
