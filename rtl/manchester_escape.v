`timescale 1ps/1ps
module manchester_escape #(
    parameter integer DATA_WIDTH = 8,
    parameter ESCAPED_SYMBOL =  8'hD5,
    parameter ESCAPE_SYMBOL = 8'hE5
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

  localparam REGULAR = 0,
             ESCAPE = 1;

  reg [1:0] state;
  reg [DATA_WIDTH-1:0] m_axis_tdata_r;
  assign m_axis_tdata = m_axis_tdata_r;
  reg m_axis_tvalid_r;
  assign m_axis_tvalid = m_axis_tvalid_r;
  reg m_axis_tlast_r;
  assign m_axis_tlast = m_axis_tlast_r;
  reg local_tlast;
  reg [DATA_WIDTH-1:0]local_data;


  assign s_axis_tready = (state == REGULAR && m_axis_tready);

  always @(posedge aclk)
    begin
      if (!aresetn)
        begin
          state <=REGULAR;
          m_axis_tdata_r <= 0;
          m_axis_tvalid_r <= 0;
          m_axis_tlast_r <= 0;
          local_data <= 0;
          local_tlast <= 0;
        end
      else
        begin
          case (state)
            REGULAR:
              if (s_axis_tvalid && s_axis_tready)
                begin
                  if (s_axis_tdata == ESCAPE_SYMBOL || s_axis_tdata == ESCAPED_SYMBOL)
                    begin
                      m_axis_tdata_r <= ESCAPE_SYMBOL;
                      m_axis_tvalid_r <= 1;
                      m_axis_tlast_r <= 0;
                      local_data <= s_axis_tdata;
                      local_tlast <= s_axis_tlast;
                      state <= ESCAPE;
                    end
                  else
                    begin
                      m_axis_tdata_r <= s_axis_tdata;
                      m_axis_tvalid_r <= 1;
                      m_axis_tlast_r <= s_axis_tlast;
                    end
                end
              else
                begin
                  m_axis_tvalid_r <= 0;
                end
            ESCAPE:
              begin
                m_axis_tvalid_r <= 1;
                if (m_axis_tready)
                  begin
                    m_axis_tlast_r <= local_tlast;
                    m_axis_tdata_r <= local_data;
                    state <= REGULAR;
                  end
              end
          endcase
        end
    end

endmodule
