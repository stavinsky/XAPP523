module axis_pattern_generator (
    input wire aclk,
    input wire aresetn,

    // M_AXIS (8-bit, minimal)
    output reg  [7:0] m_axis_tdata,
    output reg        m_axis_tvalid,
    input  wire       m_axis_tready
);

  // Pattern
  localparam N = 9;
  reg [7:0] pattern[0:N-1];
  initial begin
    pattern[0] = 8'hAA;
    pattern[1] = 8'hAA;
    pattern[2] = 8'hD5;
    pattern[3] = 8'hAA;
    pattern[4] = 8'hBB;
    pattern[5] = 8'hCC;
    pattern[6] = 8'hDD;
    pattern[7] = 8'hEE;
    pattern[8] = 8'hFF;
  end

  // Index width (at least 1 bit)
  localparam IDX_W = (N > 1) ? $clog2(N) : 1;
  reg [IDX_W-1:0] idx;

  wire fire = m_axis_tvalid & m_axis_tready;

  always @(posedge aclk) begin
    if (!aresetn) begin
      idx           <= 0;
      m_axis_tdata  <= pattern[0];
      m_axis_tvalid <= 1'b1;  // always driving, backpressure via tready
    end else begin
      m_axis_tvalid <= 1'b1;
      if (fire) begin
        if (idx == N - 1) begin
          idx          <= 0;
          m_axis_tdata <= pattern[0];
        end else begin
          idx          <= idx + 1'b1;
          m_axis_tdata <= pattern[idx+1'b1];
        end
      end
    end
  end

endmodule
