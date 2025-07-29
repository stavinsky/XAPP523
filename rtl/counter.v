module counter (
    input wire clk,       // Clock input
    input wire rst,       // Synchronous reset (active high)
    output reg [7:0] count // 8-bit counter output
  );

  always @(posedge clk)
    begin
      if (rst)
        count <= 8'b0;          // Reset counter to 0
      else
        count <= count + 1'b1;  // Increment counter
    end

endmodule
