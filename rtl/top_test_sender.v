`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/12/2025 10:55:22 PM
// Design Name: 
// Module Name: top_test_sender
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_test_sender(
output wire  serial_out,
input wire  clk
    );
    wire clk_100;
    wire aresetn;
    clk_wiz_0 pll ( .clk_in1(clk), .clk_out1(clk_100), .locked(aresetn)

    );
    test_pattern tp1 (
    .clk(clk_100),
    .aresetn(aresetn),
    .serial_out(serial_out)
    );
endmodule
