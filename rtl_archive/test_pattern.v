module test_pattern (
    input  wire clk,
    input  wire aresetn,
    output wire serial_out
);
  reg data_bit;
  reg [4:0] cnt;
  reg [31:0] data;
  assign serial_out = clk ^ data_bit;
  always @(posedge clk) begin
    if (!aresetn) begin
      cnt <= 0;
      data <= 32'hAA550FF0;
      data_bit <= 0;
    end else begin
      data_bit <= data[cnt];
      cnt <= cnt + 1'b1;
    end
  end
endmodule
