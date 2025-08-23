//Copyright (C)2014-2025 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//Tool Version: V1.9.11.03 
//Created Time: 2025-08-22 23:56:33
//create_clock -name sys_clk -period 10 -waveform {0 1.667} [get_ports {sys_clk}]
//create_clock -name clk_108 -period 3.333 -waveform {0 1.667} [get_nets {clk108}]
//create_generated_clock -name div4 -source [get_nets {clk108}] -master_clock clk_108 -divide_by 4 [get_nets {ce_div[1]}]
//set_false_path -from [get_clocks {div4}] -to [get_clocks {clk_108}] 
//set_false_path -from [get_clocks {clk_108}] -to [get_clocks {div4}] 
