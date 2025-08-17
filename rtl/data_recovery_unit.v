module data_recovery_unit (
    input wire [7:0] sample_window,
    input wire clk,
    input wire aresetn,

    output reg [2:0] out,
    (* MARK_DEBUG="true" *)    output reg [1:0] num_bits

);
  reg  [7:0] sw;
  wire [3:0] E;

  always @(posedge clk) begin
    sw <= sample_window;
  end
  reg q7_prev;
  always @(posedge clk) begin
    q7_prev <= sw[7];
  end

  assign E[0] = (sw[1] ^ ~sw[0]) | (sw[5] ^ ~sw[4]);
  assign E[1] = (sw[1] ^ ~sw[2]) | (sw[5] ^ ~sw[6]);
  assign E[2] = (sw[2] ^ ~sw[3]) | (sw[7] ^ ~sw[6]);
  assign E[3] = (sw[4] ^ ~sw[3]) | (sw[0] ^ ~q7_prev);

  (* MARK_DEBUG="true" *)reg [1:0] next_state;
  reg [1:0] state;
  always @(posedge clk) begin
    if (!aresetn) begin
      state <= 2'b00;
    end else begin
      state <= next_state;
    end
  end
  always @(*) begin
    num_bits = (state == 2'b00 && next_state == 2'b10) ? 2'd3 : (
      (state == 2'b10 && next_state == 2'b00)? 2'd1 :2'd2);
  end
  always @(posedge clk) begin
    if (!aresetn) begin
      next_state <= 2'b00;
    end else begin
      case (next_state)
        2'b00: begin
          if (E[3]) begin
            next_state <= 2'b01;
          end else if (E[0]) begin
            next_state <= 2'b10;
          end else begin
            next_state <= 2'b00;
          end
        end
        2'b01: begin
          if (E[0]) begin
            next_state <= 2'b11;
          end else if (E[1]) begin
            next_state <= 2'b00;
          end else begin
            next_state <= 2'b01;
          end
        end
        2'b10: begin
          if (E[2]) begin
            next_state <= 2'b00;
          end else if (E[3]) begin
            next_state <= 2'b11;
          end else begin
            next_state <= 2'b10;
          end
        end
        2'b11: begin
          if (E[1]) begin
            next_state <= 2'b10;
          end else if (E[2]) begin
            next_state <= 2'b01;
          end else begin
            next_state <= 2'b11;
          end
        end
        default: begin
          next_state <= next_state;
        end
      endcase
    end
  end
  always @(*) begin
    case (state)
      2'b00:   out = (num_bits == 3) ? {sw[0], sw[4], ~sw[7]} : {1'b0, sw[0], sw[4]};
      2'b01:   out = {1'b0, ~sw[1], ~sw[5]};
      2'b11:   out = {1'b0, sw[2], sw[6]};
      2'b10:   out = (num_bits == 1) ? {1'b0, 1'b0, ~sw[3]} : {1'b0, ~sw[3], ~sw[7]};
      default: out = {1'b0, ~sw[1], ~sw[5]};
    endcase
  end


endmodule
