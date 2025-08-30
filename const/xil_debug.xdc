















connect_debug_port u_ila_0/probe1 [get_nets [list {counter[0]} {counter[1]} {counter[2]} {counter[3]} {counter[4]} {counter[5]} {counter[6]} {counter[7]} {counter[8]} {counter[9]} {counter[10]} {counter[11]} {counter[12]} {counter[13]} {counter[14]} {counter[15]} {counter[16]} {counter[17]} {counter[18]} {counter[19]} {counter[20]} {counter[21]} {counter[22]} {counter[23]} {counter[24]} {counter[25]} {counter[26]} {counter[27]} {counter[28]} {counter[29]} {counter[30]} {counter[31]} {counter[32]}]]
connect_debug_port u_ila_0/probe2 [get_nets [list {error_counter[0]} {error_counter[1]} {error_counter[2]} {error_counter[3]} {error_counter[4]} {error_counter[5]} {error_counter[6]} {error_counter[7]} {error_counter[8]} {error_counter[9]} {error_counter[10]} {error_counter[11]} {error_counter[12]} {error_counter[13]} {error_counter[14]} {error_counter[15]} {error_counter[16]} {error_counter[17]} {error_counter[18]} {error_counter[19]} {error_counter[20]} {error_counter[21]} {error_counter[22]} {error_counter[23]} {error_counter[24]} {error_counter[25]} {error_counter[26]} {error_counter[27]} {error_counter[28]} {error_counter[29]} {error_counter[30]} {error_counter[31]} {error_counter[32]}]]




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
set_property port_width 32 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {data_cnt[0]} {data_cnt[1]} {data_cnt[2]} {data_cnt[3]} {data_cnt[4]} {data_cnt[5]} {data_cnt[6]} {data_cnt[7]} {data_cnt[8]} {data_cnt[9]} {data_cnt[10]} {data_cnt[11]} {data_cnt[12]} {data_cnt[13]} {data_cnt[14]} {data_cnt[15]} {data_cnt[16]} {data_cnt[17]} {data_cnt[18]} {data_cnt[19]} {data_cnt[20]} {data_cnt[21]} {data_cnt[22]} {data_cnt[23]} {data_cnt[24]} {data_cnt[25]} {data_cnt[26]} {data_cnt[27]} {data_cnt[28]} {data_cnt[29]} {data_cnt[30]} {data_cnt[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 8 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {data_out[0]} {data_out[1]} {data_out[2]} {data_out[3]} {data_out[4]} {data_out[5]} {data_out[6]} {data_out[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 32 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {err_cnt[0]} {err_cnt[1]} {err_cnt[2]} {err_cnt[3]} {err_cnt[4]} {err_cnt[5]} {err_cnt[6]} {err_cnt[7]} {err_cnt[8]} {err_cnt[9]} {err_cnt[10]} {err_cnt[11]} {err_cnt[12]} {err_cnt[13]} {err_cnt[14]} {err_cnt[15]} {err_cnt[16]} {err_cnt[17]} {err_cnt[18]} {err_cnt[19]} {err_cnt[20]} {err_cnt[21]} {err_cnt[22]} {err_cnt[23]} {err_cnt[24]} {err_cnt[25]} {err_cnt[26]} {err_cnt[27]} {err_cnt[28]} {err_cnt[29]} {err_cnt[30]} {err_cnt[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 48 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {message[0]} {message[1]} {message[2]} {message[3]} {message[4]} {message[5]} {message[6]} {message[7]} {message[8]} {message[9]} {message[10]} {message[11]} {message[12]} {message[13]} {message[14]} {message[15]} {message[16]} {message[17]} {message[18]} {message[19]} {message[20]} {message[21]} {message[22]} {message[23]} {message[24]} {message[25]} {message[26]} {message[27]} {message[28]} {message[29]} {message[30]} {message[31]} {message[32]} {message[33]} {message[34]} {message[35]} {message[36]} {message[37]} {message[38]} {message[39]} {message[40]} {message[41]} {message[42]} {message[43]} {message[44]} {message[45]} {message[46]} {message[47]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 1 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list data_out_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 1 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list tx_end_out]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk_div]
