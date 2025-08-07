`timescale 1ps / 1ps
module manchester_escape #(
    parameter integer DATA_WIDTH = 8,
    // verilog_lint: waive-start  explicit-parameter-storage-type
    parameter START_WORD = 8'hD5,
    parameter ESCAPE_SYMBOL = 8'hE5,
    parameter REPLACE_SYMBOL = 8'hF5
    // verilog_lint: waive-stop  explicit-parameter-storage-type
) (
    input wire aclk,
    input wire aresetn,

    // AXI-Stream input
    input  wire [DATA_WIDTH-1:0] s_axis_tdata,
    input  wire                  s_axis_tvalid,
    output reg                   s_axis_tready,
    input  wire                  s_axis_tlast,

    // AXI-Stream output
    output reg  [DATA_WIDTH-1:0] m_axis_tdata,
    output reg                   m_axis_tvalid,
    input  wire                  m_axis_tready,
    output reg                   m_axis_tlast
);
  // verilog_lint: waive-start  explicit-parameter-storage-type
  localparam [1:0] REGULAR = 2'd0;
  localparam [1:0] ESCAPE = 2'd1;

  // verilog_lint: waive-stop  explicit-parameter-storage-type
  reg [1:0] state;

  reg       holding;
  // assign s_axis_tready = (!holding);

  reg       local_tlast;
  reg [7:0] local_tdata;
  reg [7:0] to_replace;
  always @(*) begin
    to_replace = local_tdata == START_WORD ? REPLACE_SYMBOL : ESCAPE_SYMBOL;
  end


  reg [DATA_WIDTH-1:0] s_axis_tdata_r;
  reg                  s_axis_tvalid_r;
  reg                  s_axis_tlast_r;
  always @(posedge aclk) begin
    if (!aresetn) begin
      s_axis_tvalid_r <= 0;
    end else if (!holding) begin
      s_axis_tdata_r  <= s_axis_tdata;
      s_axis_tvalid_r <= s_axis_tvalid;
      s_axis_tlast_r  <= s_axis_tlast;
    end
  end
  always @(posedge aclk) begin
    if (!aresetn) begin
      holding       <= 0;
      m_axis_tdata  <= 0;
      m_axis_tvalid <= 0;
      m_axis_tlast  <= 0;
      s_axis_tready <= 1;
      state         <= REGULAR;
    end else begin
      case (state)
        REGULAR: begin
          local_tdata <= s_axis_tdata_r;
          local_tlast <= s_axis_tlast_r;
          if (!holding && s_axis_tvalid_r) begin
            s_axis_tready <= 0;
            holding <= 1;
            m_axis_tvalid <= 1;
            if (s_axis_tdata_r == START_WORD || s_axis_tdata_r == ESCAPE_SYMBOL) begin
              m_axis_tdata <= ESCAPE_SYMBOL;
              m_axis_tlast <= 0;
              state <= ESCAPE;

            end else begin
              m_axis_tdata <= s_axis_tdata_r;
              m_axis_tlast <= s_axis_tlast_r;
            end
          end

          if (m_axis_tvalid && m_axis_tready) begin
            m_axis_tvalid <= 0;
            holding       <= 0;
            s_axis_tready <= 1;
          end

        end
        ESCAPE: begin

          if (m_axis_tvalid && m_axis_tready) begin
            m_axis_tdata <= to_replace;
            m_axis_tlast <= local_tlast;
            state <= REGULAR;
          end else begin
            m_axis_tdata <= ESCAPE_SYMBOL;
            m_axis_tlast <= 0;
          end

        end
        default: begin
          state <= REGULAR;
        end
      endcase

    end
  end


endmodule
