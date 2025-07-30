`timescale 1ns/1ps
module  manchester_decoder #(
    parameter FRAME_SIZE=64,
    parameter START_WORD =8'hD5,
    parameter PREAMBLE_PATTERN = 8'hAA
  )(
    input  wire        aclk,
    input  wire        aresetn,
    input  wire        manchester_in,
    output wire [7:0]  m_axis_tdata,
    output wire        m_axis_tvalid,
    input wire     m_axis_tready
  );



  reg prev_in;
  reg [15:0] shift_reg;
  reg [2:0] bit_count;
  reg m_axis_tvalid_r;
  assign m_axis_tvalid = m_axis_tvalid_r;
  reg [7:0]m_axis_tdata_r;
  assign m_axis_tdata = m_axis_tdata_r;
  reg data_clk;
  reg word_valid;
  reg [8:0] word_counter;
  always @(posedge aclk )
    begin
      if (!aresetn)
        begin
          prev_in <= 0;
        end
      else
        begin
          prev_in <= manchester_in;
          data_clk <= 0;
          if (prev_in ^ manchester_in && !data_clk)
            begin
              data_clk <= 1;
              shift_reg <= {shift_reg[14:0], manchester_in};
            end
        end
    end
  reg [1:0] state;
  localparam  PREAMBLE = 0;
  localparam  TRANSACTION = 1;

  always @(posedge aclk)
    begin
      if (!aresetn)
        begin
          bit_count <= 0;
          shift_reg <= 0;
          word_valid <= 0;
          word_counter <= 0;
          state <= PREAMBLE;
        end
      else
        begin
          word_valid <= 0;
          case(state)
            PREAMBLE:
              begin
                if (shift_reg == {PREAMBLE_PATTERN,START_WORD})
                  begin
                    state <= TRANSACTION;
                    word_valid <=0;
                    bit_count <=0;
                    word_counter <= 0;
                  end
              end
            TRANSACTION:
              begin
                if (data_clk)
                  begin
                    bit_count <= bit_count + 1;
                    if (bit_count == 7)
                      begin
                        word_valid <= 1;
                        word_counter <= word_counter + 1;
                        if (word_counter == FRAME_SIZE)
                          begin
                            word_counter <= 0;
                            state <= PREAMBLE;
                          end
                      end
                  end
              end
          endcase

        end
    end
  always@(posedge aclk)
    begin
      if (!aresetn)
        begin
          m_axis_tvalid_r <= 0;
        end
      else
        begin
          if (word_valid && state==TRANSACTION )
            begin
              m_axis_tvalid_r <= 1;
              m_axis_tdata_r <= shift_reg[7:0];
            end
          if (m_axis_tvalid_r && m_axis_tready )
            begin
              m_axis_tvalid_r <= 0;
            end
        end
    end


endmodule
