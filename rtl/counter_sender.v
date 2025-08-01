`timescale 1ns / 1ps

module counter_sender (
    input  wire clk,
    output wire serial_out,
    output wire clk_out
);

  assign clk_out = clk;
  wire aresetn;
  power_on_reset por1 (
      .clk(clk),
      .reset_n(aresetn)
  );

  wire [7:0] cnt1_m_axis_tdata;
  wire cnt1_m_axis_tvalid;
  wire cnt1_m_axis_tready;
  counter cnt1 (
      .clock  (clk),
      .aresetn(aresetn),
      .tready (cnt1_m_axis_tready),
      .tdata  (cnt1_m_axis_tdata),
      .tvalid (cnt1_m_axis_tvalid)
  );

  wire unused;



  wire [7:0] framer1_m_axis_tdata;
  wire framer1_m_axis_tready;
  wire framer1_m_axis_tvalid;
  wire framer1_m_axis_tlast;
  framer #(
      .DATA_WIDTH(8),
      .FRAME_SIZE(8)
  ) framer1 (
      .clk(clk),
      .reset_n(aresetn),
      .s_axis_tdata(cnt1_m_axis_tdata),
      .s_axis_tready(cnt1_m_axis_tready),
      .s_axis_tvalid(cnt1_m_axis_tvalid),

      .m_axis_tdata (framer1_m_axis_tdata),
      .m_axis_tready(framer1_m_axis_tready),
      .m_axis_tvalid(framer1_m_axis_tvalid),
      .m_axis_tlast (framer1_m_axis_tlast)
  );

  wire [7:0] escaper1_m_axis_tdata;
  wire escaper1_m_axis_tvalid;
  wire escaper1_m_axis_tready;
  wire escaper1_m_axis_tlast;

  manchester_escape escaper1 (

      .aclk(clk),
      .aresetn(aresetn),
      .s_axis_tdata(framer1_m_axis_tdata),
      .s_axis_tvalid(framer1_m_axis_tvalid),
      .s_axis_tready(framer1_m_axis_tready),
      .s_axis_tlast(framer1_m_axis_tlast),

      .m_axis_tdata (escaper1_m_axis_tdata),
      .m_axis_tvalid(escaper1_m_axis_tvalid),
      .m_axis_tready(escaper1_m_axis_tready),
      .m_axis_tlast (escaper1_m_axis_tlast)
  );
  wire [7: 0]preamble1_m_axis_tdata;
  wire    preamble1_m_axis_tvalid;
  wire    preamble1_m_axis_tready;
  manchester_preamble preamble1 (
      .aclk(clk),
      .aresetn(aresetn),
      .s_axis_tdata(escaper1_m_axis_tdata),
      .s_axis_tvalid(escaper1_m_axis_tvalid),
      .s_axis_tready(escaper1_m_axis_tready),
      .s_axis_tlast(escaper1_m_axis_tlast),

      .m_axis_tdata (preamble1_m_axis_tdata),
      .m_axis_tvalid(preamble1_m_axis_tvalid),
      .m_axis_tready(preamble1_m_axis_tready),
      .m_axis_tlast (unused)
  );


  manchester_serializer ser1 (
      .aclk(clk),
      .aresetn(aresetn),
      .s_axis_tdata(preamble1_m_axis_tdata),
      .s_axis_tvalid(preamble1_m_axis_tvalid),
      .s_axis_tready(preamble1_m_axis_tready),

      .serial_out(serial_out)

  );

  wire [7:0] decoder1_m_axis_tdata;
  wire decoder1_m_axis_tvalid;
  wire decoder1_m_axis_tready;
  manchester_decoder #(
      .FRAME_SIZE(8)
  ) decoder1 (
      .aclk(clk),
      .aresetn(aresetn),
      .manchester_in(serial_out),
      .m_axis_tdata(decoder1_m_axis_tdata),
      .m_axis_tvalid(decoder1_m_axis_tvalid),
      .m_axis_tready(1)
  );

endmodule
