create_project -force xil_test_receiver ./xil_test_receiver -part xc7z010clg400-2
add_files {
    rtl/top_receiver_xilinix.v
    rtl/manchester_decoder2.v
    rtl/data_recovery_unit.v
    ip/clk_wiz_0_1/clk_wiz_0_1.xci
    rtl/oversample.v

}
add_files -fileset constrs_1 {
    const/const.xdc
    const/xil_debug.xdc

}