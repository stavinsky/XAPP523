

set_property PACKAGE_PIN M19 [get_ports sys_clk]
set_property IOSTANDARD LVCMOS33 [get_ports sys_clk]
set_property PACKAGE_PIN G15 [get_ports serial_out_diff_p]

create_clock -period 20.000 -name sys_clk -waveform {0.000 10.000} [get_ports sys_clk]


set_property OFFCHIP_TERM NONE [get_ports serial_out_diff_p]
