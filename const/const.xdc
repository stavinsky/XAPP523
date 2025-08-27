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

set_max_delay -datapath_only -from [get_pins {oversample_inst/iserdes_inst/Q1 oversample_inst/iserdes_inst/Q2 oversample_inst/iserdes_inst/Q3 oversample_inst/iserdes_inst/Q4 oversample_inst/iserdes_inst_90/Q1 oversample_inst/iserdes_inst_90/Q2 oversample_inst/iserdes_inst_90/Q3 oversample_inst/iserdes_inst_90/Q4}] -to [get_pins -hierarchical *sw_reg*/D*] 0.600












