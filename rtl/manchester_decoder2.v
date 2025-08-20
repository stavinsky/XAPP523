module manchester_decoder2 (
    input wire aclk,
    input wire aresetn,
    input wire [2:0] bits,
    input wire [1:0] num_bits,
    output reg [1:0] decoded_bits,
    output reg [1:0] num_decoded_bits
);

  reg [3:0] btd;  // bits to decode
  reg [2:0] nbtd;
  reg stored_flag_q;
  reg stored_flag;
  reg stored_q;
  reg stored;
  reg [2:0] i;
  always @* begin
    btd = {1'b0, bits};
    stored = stored_q;
    stored_flag = stored_flag_q;
    btd[num_bits] = stored;
    num_decoded_bits = 0;
    decoded_bits = 0;
    // nbtd = (stored_flag) ? num_bits + 1'd1 : {1'b0, num_bits};
    nbtd = {1'b0, num_bits} + (stored_flag ? 3'd1 : 3'd0);
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
  (* MARK_DEBUG="TRUE" *) reg [7:0] shift;
  always @(posedge aclk) begin
    if (!aresetn) begin
      shift <= 0;
    end else begin
      if (num_decoded_bits == 1) begin
        shift <= {shift[6:0], decoded_bits[0]};
      end else if (num_decoded_bits == 2) begin
        shift <= {shift[5:0], decoded_bits[0], decoded_bits[1]};
      end
    end
  end
endmodule
