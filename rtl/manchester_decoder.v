module manchester_decoder (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        manchester_in,
    input  wire        sample_en,
    output wire [7:0]  data_out,
    output wire        data_valid
  );

  parameter IDLE   = 2'b00;
  parameter SYNC   = 2'b01;
  parameter DECODE = 2'b10;

  reg [1:0] state;

  reg prev_in;
  reg [7:0] shift_reg;
  reg [2:0] bit_count;
  reg data_valid_r;
  assign data_valid = data_valid_r;
  assign data_out = shift_reg;
  reg skip;
  always @(posedge clk)
    begin
      if (!rst_n)
        begin
          state <= IDLE;
          bit_count <= 0;
          shift_reg <= 0;
          data_valid_r <= 0;
        end
      else
        begin
          prev_in <= manchester_in;
          case(state)
            IDLE:
              begin
                if (sample_en)
                  begin
                    state <= DECODE;
                  end
              end
            SYNC:
              begin
              end
            DECODE:
              begin
                skip <= 0;
                data_valid_r <= 0;
                if (prev_in ^ manchester_in && !skip)
                  begin
                    shift_reg <= {shift_reg[6:0], manchester_in};
                    bit_count <= bit_count + 1;
                    skip <= 1;
                    if (bit_count == 7)
                      begin
                        data_valid_r <= 1;
                      end
                  end

              end
          endcase
        end
    end
    

endmodule
