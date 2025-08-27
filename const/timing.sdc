//Copyright (C)2014-2025 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//Tool Version: V1.9.11.03 
//Created Time: 2025-08-27 01:16:57
create_clock -name sys_clk -period 10 -waveform {0 5} [get_ports {sys_clk}]
create_generated_clock -name clk_300 -source [get_ports {sys_clk}] -master_clock sys_clk -multiply_by 4 [get_nets {clk108}]
create_generated_clock -name div_4 -source [get_nets {clk108}] -master_clock clk_300 -divide_by 4 [get_nets {pclk_ce}]
