create_project -name gw_test_tx -dir ./ -pn  GW2AR-LV18QN88C8/I7 -device_version C
add_file ../const/timing.sdc
add_file ../const/tang_nano_9k.cst
add_file ../rtl/gw_pll_300mhz.v
add_file ../rtl/manchester_encoder.v
add_file ../rtl/top_gowin.v

set_option -top_module top_gowin

run all