tb: tb_manchester_encoder.vcd tb_manchester_preamble.vcd

tb_manchester_encoder: rtl/*.v
	iverilog -y ./rtl -o tb_manchester_encoder rtl/tb_manchester_encoder.v  rtl/manchester_serial_top.v

tb_manchester_encoder.vcd: tb_manchester_encoder
	vvp tb_manchester_encoder


tb_manchester_preamble: rtl/*.v
	iverilog -y ./rtl -o tb_manchester_preamble rtl/tb_manchester_preamble.v  rtl/manchester_preamble.v
tb_manchester_preamble.vcd: tb_manchester_preamble
	vvp tb_manchester_preamble


.PHONY: clean 

clean: 
	rm -rf *.vcd
	rm -rf tb_manchester_encoder
	rm -rf tb_manchester_preamble