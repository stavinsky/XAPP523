












create_pblock sw_reg1
add_cells_to_pblock [get_pblocks sw_reg1] [get_cells -quiet [list {dru/sw_reg[0]} {dru/sw_reg[1]} {dru/sw_reg[2]} {dru/sw_reg[3]} {dru/sw_reg[4]} {dru/sw_reg[5]} {dru/sw_reg[6]} {dru/sw_reg[7]}]]
resize_pblock [get_pblocks sw_reg1] -add {SLICE_X42Y19:SLICE_X43Y20}

create_pblock sw_r1
add_cells_to_pblock [get_pblocks sw_r1] [get_cells -quiet [list {dru/sw_r_reg[0]} {dru/sw_r_reg[1]} {dru/sw_r_reg[2]} {dru/sw_r_reg[3]} {dru/sw_r_reg[4]} {dru/sw_r_reg[5]} {dru/sw_r_reg[6]} {dru/sw_r_reg[7]}]]
resize_pblock [get_pblocks sw_r1] -add {SLICE_X40Y19:SLICE_X41Y20}



create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 16384 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list pll1/inst/clk_div]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 8 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {data_out[0]} {data_out[1]} {data_out[2]} {data_out[3]} {data_out[4]} {data_out[5]} {data_out[6]} {data_out[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 1 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list data_out_valid]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk_div]
