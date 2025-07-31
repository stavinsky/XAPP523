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

set_property -dict {PACKAGE_PIN K17 IOSTANDARD LVCMOS33} [get_ports clk]
set_property -dict {PACKAGE_PIN P20 IOSTANDARD LVCMOS33} [get_ports clk_out]
set_property -dict {PACKAGE_PIN T20 IOSTANDARD LVCMOS33} [get_ports serial_out]




#set_property -dict {PACKAGE_PIN P14  IOSTANDARD LVCMOS33} [get_ports {led[0]}]

#set_property -dict {PACKAGE_PIN R14 IOSTANDARD LVCMOS33} [get_ports key]


#set_property CLOCK_DEDICATED_ROUTE BACKBONE [get_nets design_1_i/clk_wiz_0/inst/clk_in1_design_1_clk_wiz_0_0]

#set_property INTERNAL_VREF 0.675 [get_iobanks 34]
#set_property INTERNAL_VREF 0.675 [get_iobanks 35]

#set_property -dict {PACKAGE_PIN R17 IOSTANDARD LVCMOS33} [get_ports sd_dclk]
#set_property -dict {PACKAGE_PIN P19 IOSTANDARD LVCMOS33} [get_ports sd_ncs]
#set_property -dict {PACKAGE_PIN V18 IOSTANDARD LVCMOS33} [get_ports sd_mosi]
#set_property -dict {PACKAGE_PIN R18 IOSTANDARD LVCMOS33} [get_ports sd_miso]




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
connect_debug_port u_ila_0/clk [get_nets [list clk_out_OBUF_BUFG]]
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe0]
set_property port_width 8 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {framer1_m_axis_tdata[0]} {framer1_m_axis_tdata[1]} {framer1_m_axis_tdata[2]} {framer1_m_axis_tdata[3]} {framer1_m_axis_tdata[4]} {framer1_m_axis_tdata[5]} {framer1_m_axis_tdata[6]} {framer1_m_axis_tdata[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe1]
set_property port_width 8 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {decoder1_m_axis_tdata[0]} {decoder1_m_axis_tdata[1]} {decoder1_m_axis_tdata[2]} {decoder1_m_axis_tdata[3]} {decoder1_m_axis_tdata[4]} {decoder1_m_axis_tdata[5]} {decoder1_m_axis_tdata[6]} {decoder1_m_axis_tdata[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe2]
set_property port_width 8 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {escaper1_m_axis_tdata[0]} {escaper1_m_axis_tdata[1]} {escaper1_m_axis_tdata[2]} {escaper1_m_axis_tdata[3]} {escaper1_m_axis_tdata[4]} {escaper1_m_axis_tdata[5]} {escaper1_m_axis_tdata[6]} {escaper1_m_axis_tdata[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe3]
set_property port_width 8 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {preamble1_m_axis_tdata[0]} {preamble1_m_axis_tdata[1]} {preamble1_m_axis_tdata[2]} {preamble1_m_axis_tdata[3]} {preamble1_m_axis_tdata[4]} {preamble1_m_axis_tdata[5]} {preamble1_m_axis_tdata[6]} {preamble1_m_axis_tdata[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 1 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list decoder1_m_axis_tready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 1 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list decoder1_m_axis_tvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 1 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list escaper1_m_axis_tlast]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 1 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list escaper1_m_axis_tready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 1 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list escaper1_m_axis_tvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 1 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list framer1_m_axis_tlast]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 1 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list framer1_m_axis_tready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 1 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list framer1_m_axis_tvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 1 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list preamble1_m_axis_tready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 1 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list preamble1_m_axis_tvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 1 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list serial_out_OBUF]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk_out_OBUF_BUFG]
