module data_repack (
    input wire aclk,
    input wire aresetn,
    input wire [2:0] bits,
    input wire [1:0] num_bits,
    output reg [1:0] man_bits,
    output reg [1:0] man_bits_n

);

  reg [1:0] decoded_bits;
  reg [1:0] num_decoded_bits;

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

  always @(posedge aclk) begin
    man_bits_n <= num_decoded_bits;
    man_bits <= decoded_bits;
  end
endmodule
