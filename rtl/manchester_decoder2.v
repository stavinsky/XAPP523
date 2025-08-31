module manchester_decoder2 #(
    parameter FRAME_SIZE = 6
) (
    input wire aclk,
    input wire aresetn,
    input wire [2:0] bits,
    input wire [1:0] num_bits,
    output reg [7:0] decoded_byte,
    output reg byte_valid,
    output reg tx_end

);

  wire [1:0] man_bits;
  wire [1:0] man_bits_n;

  data_repack repacker (
      .aclk(aclk),
      .aresetn(aresetn),
      .bits(bits),
      .num_bits(num_bits),
      .man_bits(man_bits),
      .man_bits_n(man_bits_n)
  );

  reg [15:0] shift;
  always @(posedge aclk) begin
    if (!aresetn) begin
      shift <= 0;
    end else begin
      if (man_bits_n == 1) begin
        shift <= {shift[14:0], man_bits[0]};
      end else if (man_bits_n == 2) begin
        shift <= {shift[13:0], man_bits[0], man_bits[1]};
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
      tx_end <= 1'b0;
    end else begin
      case (state)
        state_preamble: begin
          byte_valid <= 0;
          tx_end <= 0;
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
              tx_end <= 1;
            end
          end else if (cnt == 8) begin
            decoded_byte <= shift[8:1];
            cnt <= 1;
            byte_valid <= 1;
            byte_counter <= byte_counter + 1;
            if (byte_counter == FRAME_SIZE - 1) begin
              byte_counter <= 0;
              state <= state_preamble;
              tx_end <= 1;
            end
          end else begin
            decoded_byte <= decoded_byte;
            cnt <= cnt + {2'b0, man_bits_n};
            byte_valid <= 0;
            tx_end <= 0;
          end
        end
        default: begin
          state <= state_preamble;
        end
      endcase
    end
  end
endmodule
