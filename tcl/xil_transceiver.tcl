create_project -force xil_test_transceiver ./xil_test_transceiver -part xc7z020clg484-2
add_files {
    rtl/manchester_encoder.v
    rtl/top_transceiver.v
    ip/tx_clk/tx_clk.xci
}
add_files -fileset constrs_1 {
    const/test_sender.xdc
