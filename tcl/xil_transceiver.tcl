create_project -force xil_test_transceiver ./xil_test_transceiver -part xc7z020clg484-2
add_files {
    rtl/top_transceiver.v
    ip/tx_clk/tx_clk.xci
    rtl/axis_manchester_encoder.v
    rtl/axis_pattern_generator.v

}
add_files -fileset constrs_1 {
    const/test_sender.xdc
}