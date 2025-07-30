module  manchester_decoder(
    input  wire        aclk,
    input  wire        aresetn,
    input  wire        manchester_in,
    output wire [7:0]  m_axis_tdata,
    output wire        m_axis_tvalid,
    input wire     m_axis_tready
  );



  reg prev_in;
  reg [7:0] shift_reg;
  reg [2:0] bit_count;
  reg m_axis_tvalid_r;
  assign m_axis_tvalid = m_axis_tvalid_r;
  reg [7:0]m_axis_tdata_r;
  assign m_axis_tdata = m_axis_tdata_r;
  reg skip;
  always @(posedge aclk)
    begin
      if (!aresetn)
        begin
          bit_count <= 0;
          shift_reg <= 0;
        end
      else
        begin
          prev_in <= manchester_in;
          begin
            skip <= 0;
            if (prev_in ^ manchester_in && !skip)
              begin
                skip <= 1;
                shift_reg <= {shift_reg[6:0], manchester_in};
                bit_count <= bit_count + 1;
              end
          end
        end
    end
  reg [2:0]bit_count_latch;
  always@(posedge aclk)
    begin
      if (!aresetn)
        begin
          m_axis_tvalid_r <= 0;
          bit_count_latch <= 0;
        end
      else
        begin
          bit_count_latch <= bit_count;
          if (bit_count_latch == 7 && bit_count == 0)
            begin
              m_axis_tdata_r <= shift_reg;
              m_axis_tvalid_r <= 1;
            end
          if (m_axis_tvalid_r && m_axis_tready )
            begin
              m_axis_tvalid_r <= 0;
            end
        end
    end


endmodule
