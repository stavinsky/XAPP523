`timescale 1ps/1ps
module manchester_escape #(
    parameter integer DATA_WIDTH = 8,
    parameter ESCAPED_SYMBOL =  8'hD5,
    parameter ESCAPE_SYMBOL = 8'hE5,
    parameter REPLACE_SYMBOL = 8'hF5
  )(
    input  wire                   aclk,
    input  wire                   aresetn,

    // AXI-Stream input
    input  wire [DATA_WIDTH-1:0]  s_axis_tdata,
    input  wire                   s_axis_tvalid,
    output wire                   s_axis_tready,
    input  wire                   s_axis_tlast,

    // AXI-Stream output
    output reg [DATA_WIDTH-1:0]  m_axis_tdata,
    output reg                   m_axis_tvalid,
    input  wire                   m_axis_tready,
    output reg                   m_axis_tlast
  );

  // localparam REGULAR = 0,
  //            ESCAPE = 1;

  // reg [1:0] state;
  // reg [DATA_WIDTH-1:0] m_axis_tdata_r;
  // assign m_axis_tdata = m_axis_tdata_r;
  // reg m_axis_tvalid_r;
  // assign m_axis_tvalid = m_axis_tvalid_r;
  // reg m_axis_tlast_r;
  // assign m_axis_tlast = m_axis_tlast_r;
  // reg local_tlast;
  // reg [DATA_WIDTH-1:0]local_data;

  // reg s_axis_tready_r;
  // assign s_axis_tready = s_axis_tready_r;
  reg holding;
  assign s_axis_tready = (!holding); // accept only if not holding data

  always @(posedge aclk)
    begin
      if (!aresetn)
        begin
          holding       <= 0;
          m_axis_tdata  <= 0;
          m_axis_tvalid <= 0;
          m_axis_tlast  <= 0;
        end
      else
        begin
          // Accept input if we're not holding data
          if (!holding && s_axis_tvalid)
            begin
              m_axis_tdata  <= s_axis_tdata;
              m_axis_tlast  <= s_axis_tlast;
              m_axis_tvalid <= 1;
              holding       <= 1;
            end

          // If output is accepted, release the hold
          if (m_axis_tvalid && m_axis_tready)
            begin
              m_axis_tvalid <= 0;
              holding       <= 0;
            end
        end
    end
  // always @(posedge aclk)
  //   begin
  //     if (!aresetn)
  //       begin
  //         state <=REGULAR;
  //         m_axis_tdata_r <= 0;
  //         m_axis_tvalid_r <= 0;
  //         m_axis_tlast_r <= 0;
  //         s_axis_tready_r <= 1;
  //         local_data <= 0;
  //         local_tlast <= 0;
  //         holding <= 0;
  //       end
  //     else
  //       begin
  //         if (s_axis_tready && s_axis_tvalid && !holding)
  //           begin
  //             m_axis_tdata_r <= s_axis_tdata;
  //             m_axis_tvalid_r <= 1'b1;
  //             s_axis_tready_r <= 1'b0;
  //           end
  //         if (m_axis_tready && m_axis_tvalid)
  //           begin
  //             m_axis_tvalid_r <= 0;
  //             s_axis_tready_r <= 1;
  //           end


  //         // case (state)
  //         //   REGULAR:
  //         //     begin
  //         //       if (s_axis_tvalid && s_axis_tready)
  //         //         begin
  //         //           if (s_axis_tdata == ESCAPE_SYMBOL || s_axis_tdata == ESCAPED_SYMBOL)
  //         //             begin
  //         //               m_axis_tdata_r <= ESCAPE_SYMBOL;
  //         //               m_axis_tvalid_r <= 1;
  //         //               m_axis_tlast_r <= 0;
  //         //               local_data <= s_axis_tdata;
  //         //               local_tlast <= s_axis_tlast;
  //         //               state <= ESCAPE;
  //         //             end
  //         //           else
  //         //             begin
  //         //               m_axis_tdata_r <= s_axis_tdata;
  //         //               m_axis_tvalid_r <= 1;
  //         //               m_axis_tlast_r <= s_axis_tlast;
  //         //             end
  //         //         end
  //         //       else
  //         //         begin
  //         //           m_axis_tvalid_r <= 0;
  //         //         end
  //         //     end
  //         //   ESCAPE:
  //         //     begin
  //         //       // m_axis_tvalid_r <= 1;
  //         //       if (m_axis_tready)
  //         //         begin
  //         //           m_axis_tlast_r <= local_tlast;
  //         //           // m_axis_tdata_r <= local_data;
  //         //           m_axis_tdata_r <= local_data == ESCAPED_SYMBOL ? REPLACE_SYMBOL: ESCAPE_SYMBOL;

  //         //           state <= REGULAR;
  //         //           m_axis_tvalid_r <= 0;
  //         //         end
  //         //     end
  //         // endcase
  //       end
  //   end

endmodule
