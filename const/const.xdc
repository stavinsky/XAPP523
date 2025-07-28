set_property -dict {PACKAGE_PIN R4 IOSTANDARD DIFF_SSTL15} [get_ports sys_clk_p]
set_property -dict {PACKAGE_PIN V20 IOSTANDARD LVCMOS33} [get_ports sys_rstn]
#set_property -dict {PACKAGE_PIN V17 IOSTANDARD LVCMOS33} [get_ports uart_txd]
#set_property -dict {PACKAGE_PIN W17 IOSTANDARD LVCMOS33} [get_ports uart_rxd]
#set_property CFGBVS VCCO [current_design]
#set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS true [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property BITSTREAM.CONFIG.SPI_FALL_EDGE Yes [current_design]






#set_property -dict {PACKAGE_PIN P14  IOSTANDARD LVCMOS33} [get_ports {led[0]}]

#set_property -dict {PACKAGE_PIN R14 IOSTANDARD LVCMOS33} [get_ports key]


#set_property CLOCK_DEDICATED_ROUTE BACKBONE [get_nets design_1_i/clk_wiz_0/inst/clk_in1_design_1_clk_wiz_0_0]

#set_property INTERNAL_VREF 0.675 [get_iobanks 34]
#set_property INTERNAL_VREF 0.675 [get_iobanks 35]

#set_property -dict {PACKAGE_PIN R17 IOSTANDARD LVCMOS33} [get_ports sd_dclk]
#set_property -dict {PACKAGE_PIN P19 IOSTANDARD LVCMOS33} [get_ports sd_ncs]
#set_property -dict {PACKAGE_PIN V18 IOSTANDARD LVCMOS33} [get_ports sd_mosi]
#set_property -dict {PACKAGE_PIN R18 IOSTANDARD LVCMOS33} [get_ports sd_miso]
