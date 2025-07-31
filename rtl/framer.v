`timescale 1ns / 1ps

module framer#(parameter FRAME_SIZE = 64, DATA_WIDTH=32)(
    input clk,

    input [DATA_WIDTH-1:0]s_axis_tdata,
    output s_axis_tready,
    input s_axis_tvalid,

    output [DATA_WIDTH-1:0]m_axis_tdata,
    input m_axis_tready,
    output m_axis_tvalid,
    output m_axis_tlast,
    input reset_n
  );
  reg [18:0]counter;
  assign m_axis_tdata = s_axis_tdata;
  assign s_axis_tready = m_axis_tready;
  assign m_axis_tvalid = s_axis_tvalid;
  wire tlast_pulse;
  assign tlast_pulse  = (counter == FRAME_SIZE -1) & s_axis_tvalid & m_axis_tready;
  assign m_axis_tlast = tlast_pulse;

  always @(posedge clk)
    begin

      if (!reset_n)
        begin
          counter <= 0;
        end
      else
        begin
          if (s_axis_tvalid & m_axis_tready)
            begin
              if (counter == FRAME_SIZE - 1)
                begin
                  counter <= 0;
                end
              else
                begin
                  counter <= counter + 1'b1;
                end
            end

        end
    end

endmodule
