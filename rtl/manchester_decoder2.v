module manchester_decoder2 #(
    parameter FRAME_SIZE = 6
) (
    input wire aclk,
    input wire aresetn,
    input wire [2:0] bits,
    input wire [1:0] num_bits,
    output reg [1:0] decoded_bits,
    output reg [1:0] num_decoded_bits,
    output reg [7:0] decoded_byte,
    output reg byte_valid

);

  reg [3:0] btd;  // bits to decode
  reg [2:0] nbtd;  //num bits to decode
  reg stored_flag_q;
  reg stored_flag;
  reg stored_q;
  reg stored;
  reg [2:0] i;

  reg [2:0] bits_r;
  reg [1:0] num_bits_r;
  always @(posedge aclk) begin
    bits_r <= bits;
    num_bits_r <= num_bits;

  end
  always @* begin
    btd = {1'b0, bits_r};
    stored = stored_q;
    stored_flag = stored_flag_q;
    btd[num_bits_r] = stored;
    num_decoded_bits = 0;
    decoded_bits = 0;
    nbtd = {1'b0, num_bits_r} + (stored_flag ? 3'd1 : 3'd0);
    for (i = 0; i < 4; i = i + 1) begin
      if (nbtd > 1) begin
        if (btd[nbtd-1] ^ btd[nbtd-2]) begin
          num_decoded_bits = num_decoded_bits + 1;
          decoded_bits[num_decoded_bits-1] = btd[nbtd-2];
          nbtd = nbtd - 2;

        end else begin
          nbtd = nbtd - 1;
        end
      end
    end
    if (nbtd == 1) begin
      stored = btd[0];
      stored_flag = 1'b1;
    end else begin
      stored = 1'b0;
      stored_flag = 1'b0;
    end
  end
  always @(posedge aclk) begin
    if (!aresetn) begin
      stored_flag_q <= 1'b0;
      stored_q <= 1'b0;
    end else begin
      stored_q <= stored;
      stored_flag_q <= stored_flag;
    end
  end

  reg [1:0] num_decoded_bits_r;
  reg [1:0] decoded_bits_r;

  always @(posedge aclk) begin
    num_decoded_bits_r <= num_decoded_bits;
    decoded_bits_r <= decoded_bits;
  end

  reg [15:0] shift;
  always @(posedge aclk) begin
    if (!aresetn) begin
      shift <= 0;
    end else begin
      if (num_decoded_bits_r == 1) begin
        shift <= {shift[14:0], decoded_bits_r[0]};
      end else if (num_decoded_bits_r == 2) begin
        shift <= {shift[13:0], decoded_bits_r[0], decoded_bits_r[1]};
      end
    end
  end
  localparam state_preamble = 0;
  localparam state_data = 1;
  reg [1:0] state;
  reg [3:0] cnt;
  reg [3:0] byte_counter;

  always @(posedge aclk) begin
    if (!aresetn) begin
      state <= state_preamble;
      cnt <= 0;
      byte_counter <= 0;
    end else begin
      case (state)
        state_preamble: begin
          byte_valid <= 0;
          if (shift == 16'hAAD5) begin
            state <= state_data;
            cnt   <= 0;
          end
        end
        state_data: begin
          if (cnt == 7) begin
            decoded_byte <= shift[7:0];
            byte_valid <= 1'b1;
            cnt <= 0;
            byte_counter <= byte_counter + 1;
            if (byte_counter == FRAME_SIZE - 1) begin
              byte_counter <= 0;
              state <= state_preamble;
            end
          end else if (cnt == 8) begin
            decoded_byte <= shift[8:1];
            cnt <= 1;
            byte_valid <= 1;
            byte_counter <= byte_counter + 1;
            if (byte_counter == FRAME_SIZE - 1) begin
              byte_counter <= 0;
              state <= state_preamble;
            end
          end else begin
            decoded_byte <= decoded_byte;
            cnt <= cnt + {2'b0, num_decoded_bits_r};
            byte_valid <= 0;
          end
        end
        default: begin
          state <= state_preamble;
        end
      endcase
    end
  end
endmodule
