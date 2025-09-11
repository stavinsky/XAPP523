module axis_manchester_encoder (
    input wire aclk,
    input wire aresetn,

    input  wire [7:0] s_axis_tdata,
    input  wire       s_axis_tvalid,
    output wire       s_axis_tready,

    output reg  [7:0] m_axis_tdata,
    output reg        m_axis_tvalid,
    input  wire       m_axis_tready
);

  import manch_pkg::encode;
  typedef enum logic [1:0] {IDLE, OUT_HI, OUT_LO} state_e;
  state_e state;

  reg  [3:0] d_reg;

  wire       in_fire = s_axis_tvalid & s_axis_tready;
  wire       out_fire = m_axis_tvalid & m_axis_tready;

  assign s_axis_tready = ((state == IDLE) || ((state == OUT_HI) && m_axis_tready));

  always_ff @(posedge aclk) begin
    if (!aresetn) begin
      state         <= IDLE;
      d_reg         <= 4'h0;
      m_axis_tdata  <= 8'h00;
      m_axis_tvalid <= 1'b0;
    end else begin
      unique case (state)
        IDLE: begin
          m_axis_tvalid <= 1'b0;
          if (in_fire) begin
            d_reg         <= s_axis_tdata[3:0];
            m_axis_tdata  <= encode(s_axis_tdata[7:4]);
            m_axis_tvalid <= 1'b1;
            state         <= OUT_HI;
          end
        end

        OUT_HI: begin
          if (out_fire) begin
            m_axis_tdata  <= encode(d_reg[3:0]);
            m_axis_tvalid <= 1'b1;
            state         <= OUT_LO;
          end
        end

        OUT_LO: begin
          if (out_fire) begin
            m_axis_tvalid <= 1'b0;
            state         <= IDLE;
            if (in_fire) begin
              m_axis_tvalid <= 1'b1;
              m_axis_tdata <= encode(s_axis_tdata[7:4]);
              d_reg <= s_axis_tdata[3:0];
              state <= OUT_HI;
            end
          end
        end

        default: begin
          state         <= IDLE;
          m_axis_tvalid <= 1'b0;
        end
      endcase
    end
  end

endmodule
