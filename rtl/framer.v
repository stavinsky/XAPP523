`timescale 1ns / 1ps

module framer #(
    parameter FRAME_SIZE = 64,
    DATA_WIDTH = 32
) (
    input clk,

    input [DATA_WIDTH-1:0] s_axis_tdata,
    output wire s_axis_tready,
    input s_axis_tvalid,

    output reg [DATA_WIDTH-1:0] m_axis_tdata,
    input wire m_axis_tready,
    output reg m_axis_tvalid,
    output reg m_axis_tlast,
    input reset_n
);
  reg [18:0] counter;
  reg tlast_r;
  reg holding;
  assign s_axis_tready = (!holding);

  always @(posedge clk) begin
    if (!reset_n) begin
      counter <= 0;
    end else if (!holding && s_axis_tvalid) begin
      if (tlast_r) begin
        counter <= 0;
      end else begin
        counter <= counter + 1'b1;
      end
    end
  end
  always @(posedge clk) begin
    tlast_r <= counter == FRAME_SIZE - 1;

  end

  always @(posedge clk) begin

    if (!reset_n) begin
      holding <= 0;
      m_axis_tvalid <= 0;
      m_axis_tlast <= 0;
    end else begin
      if (!holding && s_axis_tvalid) begin
        m_axis_tdata <= s_axis_tdata;
        holding <= 1'b1;
        m_axis_tvalid <= 1'b1;
        m_axis_tlast <= tlast_r;
      end
      if (m_axis_tvalid && m_axis_tready) begin
        m_axis_tvalid <= 1'b0;
        holding <= 1'b0;
        m_axis_tlast <= 1'b0;

      end

    end

  end

endmodule
