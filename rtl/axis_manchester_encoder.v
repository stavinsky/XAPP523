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

  localparam [1:0] ST_IDLE = 2'd0, ST_OUT_HI = 2'd1, ST_OUT_LO = 2'd2;

  reg  [1:0] state;
  reg  [7:0] d_reg;

  wire       in_fire = s_axis_tvalid & s_axis_tready;
  wire       out_fire = m_axis_tvalid & m_axis_tready;

  assign s_axis_tready = ((state == ST_IDLE) || (state == ST_OUT_LO) && m_axis_tready);

  always @(posedge aclk) begin
    if (!aresetn) begin
      state         <= ST_IDLE;
      d_reg         <= 8'h00;
      m_axis_tdata  <= 8'h00;
      m_axis_tvalid <= 1'b0;
    end else begin
      case (state)
        ST_IDLE: begin
          m_axis_tvalid <= 1'b0;
          if (in_fire) begin
            d_reg         <= s_axis_tdata;
            m_axis_tdata  <= man(s_axis_tdata[7:4]);
            m_axis_tvalid <= 1'b1;
            state         <= ST_OUT_HI;
          end
        end

        ST_OUT_HI: begin
          if (out_fire) begin
            m_axis_tdata  <= man(d_reg[3:0]);
            m_axis_tvalid <= 1'b1;
            state         <= ST_OUT_LO;
          end
        end

        ST_OUT_LO: begin
          if (out_fire) begin
            m_axis_tvalid <= 1'b0;
            state         <= ST_IDLE;
            if (in_fire) begin
              m_axis_tvalid <= 1'b1;
              m_axis_tdata <= man(s_axis_tdata[7:4]);
              d_reg <= s_axis_tdata;
              state <= ST_OUT_HI;
            end
          end
        end

        default: begin
          state         <= ST_IDLE;
          m_axis_tvalid <= 1'b0;
        end
      endcase
    end
  end
  function automatic [7:0] man(input reg [3:0] in);
    begin
      man[7] = ~in[3];
      man[6] = in[3];
      man[5] = ~in[2];
      man[4] = in[2];
      man[3] = ~in[1];
      man[2] = in[1];
      man[1] = ~in[0];
      man[0] = in[0];
    end
  endfunction
endmodule
