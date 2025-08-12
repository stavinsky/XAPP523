module data_recovery_unit (
    input wire [7:0] sample_window,
    input wire clk,
    output reg [7:0] sw,
    output reg [3:0] E,
    output reg [1:0] out,

    input wire aresetn
);
  //   reg [7:0] sw;
  always @(posedge clk) begin
    sw <= sample_window;
  end
  reg q7_prev;
  always @(posedge clk) begin
    q7_prev <= sw[7];
  end

  //   (* MARK_DEBUG="true" *) reg [3:0] E;

  //  end
  // verilog_lint: waive-start always-comb
  // always @(*) begin
  //   E[0] = (sw[1] ^ ~sw[0]) | (sw[5] ^ ~sw[4]);
  //   E[1] = (sw[1] ^ ~sw[2]) | (sw[5] ^ ~sw[6]);
  //   E[2] = (sw[2] ^ ~sw[3]) | (sw[7] ^ ~sw[6]);
  //   E[3] = (sw[4] ^ ~sw[3]) | (sw[0] ^ ~q7_prev);
  // end
  // reg [3:0] E;
  always @(posedge clk) begin
    E[0] <= (sw[1] ^ ~sw[0]) | (sw[5] ^ ~sw[4]);
    E[1] <= (sw[1] ^ ~sw[2]) | (sw[5] ^ ~sw[6]);
    E[2] <= (sw[2] ^ ~sw[3]) | (sw[7] ^ ~sw[6]);
    E[3] <= (sw[4] ^ ~sw[3]) | (sw[0] ^ ~q7_prev);
  end
  // verilog_lint: waive-stop always-comb

  (* MARK_DEBUG="true" *) reg [1:0] state;
  always @(posedge clk) begin
    if (!aresetn) begin
      state <= 2'b01;
    end else begin
      case (state)
        2'b00: begin
          if (E[3]) begin
            state <= 2'b01;
          end else if (E[0]) begin
            state <= 2'b10;
          end else begin
            state <= 2'b00;
          end
        end
        2'b01: begin
          if (E[0]) begin
            state <= 2'b11;
          end else if (E[1]) begin
            state <= 2'b00;
          end else begin
            state <= 2'b01;
          end
        end
        2'b10: begin
          if (E[2]) begin
            state <= 2'b00;
          end else if (E[3]) begin
            state <= 2'b11;
          end else begin
            state <= 2'b10;
          end
        end
        2'b11: begin
          if (E[1]) begin
            state <= 2'b10;
          end else if (E[2]) begin
            state <= 2'b01;
          end else begin
            state <= 2'b11;
          end
        end
      endcase
    end
  end
  always @(*) begin
    out = 2'b00;
    case (state)
      2'b00: begin
        out = {sw[0], sw[4]};
      end
      2'b01: begin
        out = {~sw[1], ~sw[5]};
      end
      2'b10: begin
        out = {sw[2], sw[6]};
      end
      2'b11: begin
        out = {~sw[3], ~sw[7]};
      end
    endcase
  end

endmodule
