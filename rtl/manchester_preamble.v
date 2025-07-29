`timescale 1ns / 1ps
module manchester_preamble #(
    parameter integer DATA_WIDTH = 8
  )(
    input  wire                   aclk,
    input  wire                   aresetn,

    // AXI-Stream input
    input  wire [DATA_WIDTH-1:0]  s_axis_tdata,
    input  wire                   s_axis_tvalid,
    output wire                   s_axis_tready,
    input  wire                   s_axis_tlast,

    // AXI-Stream output
    output wire [DATA_WIDTH-1:0]  m_axis_tdata,
    output wire                   m_axis_tvalid,
    input  wire                   m_axis_tready,
    output wire                   m_axis_tlast
  );

  localparam IDLE         = 2'b00,
             SEND_PREAMBLE = 2'b01,
             SEND_START    = 2'b10,
             SEND_DATA     = 2'b11,
             START_WORD = 8'hD5,
             PREAMBLE_PATTERN = 8'hAA;

  reg [1:0] state;
  reg preamble_sent;
  reg [2:0] preamble_cnt;
  reg m_axis_tvalid_r;
  assign m_axis_tvalid = m_axis_tvalid_r;
  reg [DATA_WIDTH-1: 0]m_axis_tdata_r;
  assign m_axis_tdata = m_axis_tdata_r;
  reg m_axis_tlast_r;
  assign m_axis_tlast = m_axis_tlast_r;
  reg s_axis_tready_r;
  assign s_axis_tready = s_axis_tready_r;

  always @(posedge aclk)
    begin
      if (!aresetn)
        begin
          state <= IDLE;
          preamble_sent <= 0;
          m_axis_tvalid_r <= 0;
          m_axis_tdata_r  <= 0;
          m_axis_tlast_r  <= 0;
          s_axis_tready_r <= 0;
          preamble_cnt    <= 0;
        end
      else
        begin
          m_axis_tlast_r <= 0;
          s_axis_tready_r <= 0;

          case(state)
            IDLE:
              begin
                m_axis_tvalid_r <= 0;
                if (s_axis_tvalid && m_axis_tready && preamble_sent == 0)
                  begin
                    state <= SEND_PREAMBLE;
                    preamble_cnt <= 2;
                    m_axis_tvalid_r <= 1;
                    m_axis_tdata_r <= PREAMBLE_PATTERN;
                  end
              end
            SEND_PREAMBLE:
              begin
                if (m_axis_tready)
                  begin
                    preamble_cnt <= preamble_cnt - 1;
                    if (preamble_cnt == 1)
                      begin
                        preamble_sent <= 1;
                        state <= SEND_START;
                        m_axis_tdata_r <=START_WORD;
                      end
                  end
              end
            SEND_START:
              begin
                if (m_axis_tready)
                  begin
                    state <= SEND_DATA;
                    s_axis_tready_r <= 1;
                    m_axis_tvalid_r <= 0;
                    m_axis_tdata_r <= s_axis_tdata;
                  end
              end
            SEND_DATA:
              begin
                s_axis_tready_r <= m_axis_tready;
                m_axis_tvalid_r <= s_axis_tvalid;
                m_axis_tdata_r <= s_axis_tdata;
                m_axis_tlast_r <= s_axis_tlast;

                if (s_axis_tlast)
                  begin
                    state <= IDLE;
                    preamble_sent <= 0;
                    s_axis_tready_r <= 0;
                  end
              end

          endcase
        end
    end

endmodule
