`timescale 1ns / 1ps
`include "assert_utils.vh"

module tb_main;

  localparam DATA_WIDTH = 8;
  localparam CLK_PERIOD = 10;

  reg                   aclk;
  reg                   aresetn;
  reg  [DATA_WIDTH-1:0] s_axis_tdata;
  reg                   s_axis_tvalid;
  wire                  s_axis_tready;
  reg                   s_axis_tlast;

  wire [DATA_WIDTH-1:0] m_axis_tdata;
  wire                  m_axis_tvalid;
  reg                   m_axis_tready;
  wire                  m_axis_tlast;

  initial aclk = 0;
  always #(CLK_PERIOD / 2) aclk = ~aclk;

  reg [7:0] verification_counter;
  wire [7:0] cnt1_m_axis_tdata;
  wire cnt1_m_axis_tvalid;
  wire cnt1_m_axis_tready;
  counter #() cnt1 (
      .aresetn(aresetn),
      .clock  (aclk),
      .tready (cnt1_m_axis_tready),
      .tdata  (cnt1_m_axis_tdata),
      .tvalid (cnt1_m_axis_tvalid)
  );
  wire [7:0] frm_m_axis_tdata;
  wire frm_m_axis_tvalid;
  wire frm_m_axis_tready;
  wire frm_m_axis_tlast;
  framer #(
      .DATA_WIDTH(8),
      .FRAME_SIZE(4)
  ) frm (
      .clk(aclk),
      .reset_n(aresetn),
      .s_axis_tdata(cnt1_m_axis_tdata),
      .s_axis_tready(cnt1_m_axis_tready),
      .s_axis_tvalid(cnt1_m_axis_tvalid),

      .m_axis_tdata (frm_m_axis_tdata),
      .m_axis_tready(frm_m_axis_tready),
      .m_axis_tvalid(frm_m_axis_tvalid),
      .m_axis_tlast (frm_m_axis_tlast)

  );

  wire [7:0] escape_m_axis_tdata;
  wire       escape_m_axis_tready;
  wire       escape_m_axis_tvalid;
  wire       escape_m_axis_tlast;
  manchester_escape escape (
      .aclk(aclk),
      .aresetn(aresetn),

      .s_axis_tdata (frm_m_axis_tdata),
      .s_axis_tready(frm_m_axis_tready),
      .s_axis_tvalid(frm_m_axis_tvalid),
      .s_axis_tlast (frm_m_axis_tlast),

      .m_axis_tdata (escape_m_axis_tdata),
      .m_axis_tready(escape_m_axis_tready),
      .m_axis_tvalid(escape_m_axis_tvalid),
      .m_axis_tlast (escape_m_axis_tlast)
  );
  wire [7:0] preamble_m_axis_tdata;
  wire       preamble_m_axis_tready;
  wire       preamble_m_axis_tvalid;
  wire       preamble_m_axis_tlast;
  manchester_preamble preamble (
      .aclk(aclk),
      .aresetn(aresetn),

      .s_axis_tdata (escape_m_axis_tdata),
      .s_axis_tready(escape_m_axis_tready),
      .s_axis_tvalid(escape_m_axis_tvalid),
      .s_axis_tlast (escape_m_axis_tlast),

      .m_axis_tdata (preamble_m_axis_tdata),
      .m_axis_tready(preamble_m_axis_tready),
      .m_axis_tvalid(preamble_m_axis_tvalid),
      .m_axis_tlast (preamble_m_axis_tlast)
  );
  wire serial_out;
  manchester_serializer ser (
      .aclk(aclk),
      .aresetn(aresetn),

      .s_axis_tdata(preamble_m_axis_tdata),
      .s_axis_tready(preamble_m_axis_tready),
      .s_axis_tvalid(preamble_m_axis_tvalid),
      .serial_out(serial_out)


  );

  manchester_decoder #(
      .FRAME_SIZE(4)
  ) deser (
      .aclk(aclk),
      .aresetn(aresetn),

      .m_axis_tdata (m_axis_tdata),
      .m_axis_tready(m_axis_tready),
      .m_axis_tvalid(m_axis_tvalid),
      .manchester_in(serial_out)
  );


  initial begin
    $dumpfile("tb_main.vcd");
    $dumpvars(0, tb_main);
    s_axis_tdata         = 0;
    s_axis_tvalid        = 0;
    s_axis_tlast         = 0;
    m_axis_tready        = 1;
    aresetn              = 0;
    verification_counter = 0;

    repeat (3) @(posedge aclk);
    aresetn = 1;

  end
  always @(posedge aclk) begin
    if (m_axis_tvalid && m_axis_tready) begin
      `ASSERT_EQ(m_axis_tdata, verification_counter, "");
      verification_counter <= verification_counter + 1;
      // $display("OUTPUT: %02X%s", m_axis_tdata, m_axis_tlast ? " [TLAST]" : "");

    end
    if (m_axis_tdata == 8'hFF) begin
      $finish;
    end
  end

endmodule
