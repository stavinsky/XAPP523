set_property -dict {PACKAGE_PIN K17 IOSTANDARD LVCMOS33} [get_ports clk]
#set_property -dict {PACKAGE_PIN R4 IOSTANDARD DIFF_SSTL15} [get_ports sys_clk_p]
#set_property -dict {PACKAGE_PIN V20 IOSTANDARD LVCMOS33} [get_ports sys_rstn]
#set_property -dict {PACKAGE_PIN V17 IOSTANDARD LVCMOS33} [get_ports uart_txd]
#set_property -dict {PACKAGE_PIN W17 IOSTANDARD LVCMOS33} [get_ports uart_rxd]
#set_property CFGBVS VCCO [current_design]
#set_property CONFIG_VOLTAGE 3.3 [current_design]
#set_property BITSTREAM.GENERAL.COMPRESS true [current_design]
#set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]
#set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
#set_property BITSTREAM.CONFIG.SPI_FALL_EDGE Yes [current_design]

#create_clock -period 20.000 -name clk_50M [get_ports clk]




#set_property -dict {PACKAGE_PIN P14  IOSTANDARD LVCMOS33} [get_ports {led[0]}]

#set_property -dict {PACKAGE_PIN R14 IOSTANDARD LVCMOS33} [get_ports key]


#set_property CLOCK_DEDICATED_ROUTE BACKBONE [get_nets design_1_i/clk_wiz_0/inst/clk_in1_design_1_clk_wiz_0_0]

#set_property INTERNAL_VREF 0.675 [get_iobanks 34]
#set_property INTERNAL_VREF 0.675 [get_iobanks 35]

#set_property -dict {PACKAGE_PIN R17 IOSTANDARD LVCMOS33} [get_ports sd_dclk]
#set_property -dict {PACKAGE_PIN P19 IOSTANDARD LVCMOS33} [get_ports sd_ncs]
#set_property -dict {PACKAGE_PIN V18 IOSTANDARD LVCMOS33} [get_ports sd_mosi]
#set_property -dict {PACKAGE_PIN R18 IOSTANDARD LVCMOS33} [get_ports sd_miso]


#set_property IOSTANDARD TMDS_33 [get_ports serial_out_diff_p]
#set_property PACKAGE_PIN N20 [get_ports serial_out_diff_p]
set_property PACKAGE_PIN T20 [get_ports serial_in_p]
set_property IOSTANDARD TMDS_33 [get_ports serial_in_p]
set_property IOSTANDARD TMDS_33 [get_ports serial_in_n]
set_property LOC MMCME2_ADV_X0Y0 [get_cells pll1/inst/mmcm_adv_inst]
set_property CLOCK_DEDICATED_ROUTE BACKBONE [get_nets pll1/inst/clk_in1_clk_wiz_0_1]
set_property PACKAGE_PIN N20 [get_ports test_out]
set_property IOSTANDARD LVCMOS33 [get_ports test_out]
#set_property PACKAGE_PIN N20 [get_ports test_out_p]
#set_property IOSTANDARD TMDS_33 [get_ports test_out_p]





create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list pll1/inst/clk_100]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 2 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {dru/num_bits[0]} {dru/num_bits[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 2 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {num_decoded_bits[0]} {num_decoded_bits[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 2 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {decoded_bits[0]} {decoded_bits[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 8 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {decoder/decoded_byte[0]} {decoder/decoded_byte[1]} {decoder/decoded_byte[2]} {decoder/decoded_byte[3]} {decoder/decoded_byte[4]} {decoder/decoded_byte[5]} {decoder/decoded_byte[6]} {decoder/decoded_byte[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 3 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {out[0]} {out[1]} {out[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 8 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {sample_window[0]} {sample_window[1]} {sample_window[2]} {sample_window[3]} {sample_window[4]} {sample_window[5]} {sample_window[6]} {sample_window[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 2 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {dru/next_state[0]} {dru/next_state[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 16 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {decoder/shift[0]} {decoder/shift[1]} {decoder/shift[2]} {decoder/shift[3]} {decoder/shift[4]} {decoder/shift[5]} {decoder/shift[6]} {decoder/shift[7]} {decoder/shift[8]} {decoder/shift[9]} {decoder/shift[10]} {decoder/shift[11]} {decoder/shift[12]} {decoder/shift[13]} {decoder/shift[14]} {decoder/shift[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 1 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list decoder/byte_valid]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk_100]
