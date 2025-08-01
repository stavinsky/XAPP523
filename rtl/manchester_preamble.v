`timescale 1ns / 1ps
module manchester_preamble #(
    parameter integer DATA_WIDTH = 8
) (
    input wire aclk,
    input wire aresetn,

    // AXI-Stream input
    input  wire [DATA_WIDTH-1:0] s_axis_tdata,
    input  wire                  s_axis_tvalid,
    output wire                  s_axis_tready,
    input  wire                  s_axis_tlast,

    // AXI-Stream output
    output wire [DATA_WIDTH-1:0] m_axis_tdata,
    output wire                  m_axis_tvalid,
    input  wire                  m_axis_tready,
    output wire                  m_axis_tlast
);
  // verible_lint1: waive-start parameter-name-style explicit-parameter-storage-type
  localparam IDLE         = 2'b00,
             SEND_PREAMBLE = 2'b01,
             SEND_START    = 2'b10,
             SEND_DATA     = 2'b11,
             START_WORD = 8'hD5,
             PREAMBLE_PATTERN = 8'hAA,
             PREAMBLE_TIMES = 2;

  reg [1:0] state;
  reg m_axis_tvalid_r;
  assign m_axis_tvalid = m_axis_tvalid_r;
  reg [DATA_WIDTH-1:0] m_axis_tdata_r;
  assign m_axis_tdata = m_axis_tdata_r;
  reg m_axis_tlast_r;
  assign m_axis_tlast = m_axis_tlast_r;
  reg [2:0] preamble_cnt;

  reg holding;
  assign s_axis_tready = (!holding);

  reg [7:0] local_tdata;
  reg local_tlast;

  always @(posedge aclk) begin
    if (!aresetn) begin
      state <= IDLE;
      m_axis_tvalid_r <= 0;
      m_axis_tdata_r <= 0;
      m_axis_tlast_r <= 0;
      holding <= 0;
      local_tlast <= 0;
      preamble_cnt <= PREAMBLE_TIMES;
    end else begin

      case (state)
        IDLE: begin
          if (!holding & s_axis_tvalid) begin
            holding <= 1;
            local_tdata <= s_axis_tdata;
            local_tlast <= s_axis_tlast;
            m_axis_tdata_r <= PREAMBLE_PATTERN;
            m_axis_tvalid_r <= 1;
            m_axis_tlast_r <= 0;
            state <= SEND_PREAMBLE;
            preamble_cnt <= PREAMBLE_TIMES;
          end
        end
        SEND_PREAMBLE: begin
          if (m_axis_tready) begin
            preamble_cnt <= preamble_cnt - 1;
            if (preamble_cnt == 1) begin
              state <= SEND_START;
              m_axis_tdata_r <= START_WORD;

            end
          end

        end
        SEND_START: begin

          if (m_axis_tready) begin
            state <= SEND_DATA;
            m_axis_tvalid_r <= 1;
            m_axis_tdata_r <= local_tdata;
            m_axis_tlast_r <= local_tlast;
          end
        end
        SEND_DATA: begin
          if (!holding & s_axis_tvalid) begin
            holding <= 1;
            m_axis_tdata_r <= s_axis_tdata;
            m_axis_tlast_r <= s_axis_tlast;
            m_axis_tvalid_r <= 1;
          end
          if (m_axis_tvalid && m_axis_tready) begin
            holding <= 0;
            m_axis_tvalid_r <= 0;
            if (m_axis_tlast_r) begin
              state <= IDLE;
            end
          end
        end

      endcase
    end
  end

endmodule
