module manchester_decoder2 #(
    parameter FRAME_SIZE = 4,
    parameter PREAMBLE   = 16'hAAAA,
    parameter start_word = 8'hd5
) (
    input wire aclk,
    input wire aresetn,
    input wire [2:0] bits,
    input wire [2:0] num_bits,
    input wire m_axis_tready,
    output wire m_axis_valid,
    output wire [7:0] m_axis_tdata
);
  reg [16:0] shift;

  always @(posedge aclk) begin
    if (num_bits == 2) begin
      shift <= {shift[14:0], bits[1:0]};
    end else if (num_bits == 3) begin
      shift <= {shift[13:0], bits[2:0]};
    end else begin
      shift <= {shift[15:0], bits[0:0]};
    end
  end


  reg [1:0] valid;
  always @(*) begin
    valid[0] = (shift[16] ^ shift[15] ) &
    (shift[14] ^ shift[13]) &
    (shift[12] ^ shift[11]) &
    (shift[10] ^ shift[9]) &
    (shift[8] ^ shift[7]) &
    (shift[6] ^ shift[5]) &
    (shift[4] ^shift[3]) &
    (shift[2] ^ shift[1]) ;
    valid[1] = (shift[15] ^ shift[14] ) &
    (shift[13] ^ shift[12]) &
    (shift[11] ^ shift[10]) &
    (shift[9] ^ shift[8]) &
    (shift[7] ^ shift[6]) &
    (shift[5] ^ shift[4]) &
    (shift[3] ^shift[2]) &
    (shift[1] ^ shift[0]) ;
  end
  reg [7:0] sample0;
  reg [7:0] sample1;

  always @(*) begin
    sample0 = {shift[15], shift[13], shift[11], shift[9], shift[7], shift[5], shift[3], shift[1]};
    sample1 = {shift[14], shift[12], shift[10], shift[8], shift[6], shift[4], shift[2], shift[0]};
  end
  wire preamble_valid_0;
  wire preamble_valid_1;
  assign preamble_valid_0 = (sample16_0 == 16'hAAD5) && valid[0];
  assign preamble_valid_1 = (sample16_1 == 16'hAAD5) && valid[1];

  localparam state_preamble = 0;
  localparam state_data = 1;
  reg [2:0] state;
  reg [2:0] offset;
  always @(posedge aclk) begin
    if (!aresetn) begin
      state <= 0;
    end else begin
      case (state)
        state_preamble: begin
          if (preamble_valid_0) begin
            offset <= 0;
            state  <= state_data;
          end else if (preamble_valid_1) begin
            offset <= 1;
            state  <= state_data;
          end

        end
        state_data: begin

        end
      endcase
    end

  end


endmodule
