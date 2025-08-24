IVERILOG=iverilog -I ./rtl -y ./rtl
VVP=vvp

ALL_V_FILES := $(wildcard rtl/*.v)
RTL_V_FILES := $(filter-out rtl/tb_%.v, $(ALL_V_FILES))

TESTBENCHES =  data_recovery_unit manchester_decoder2

tb: clean $(addsuffix .vcd, $(addprefix tb_, $(TESTBENCHES)))

tb_%: rtl/tb_%.v  
	$(IVERILOG) -o $@ $^

%.vcd: %
	$(VVP) $<

.PHONY: clean

clean:
	rm -f tb_* *.vcd
	find . -name "._*" -exec rm {} \;
	rm -rf vivado.*
	rm -rf vivado*
	rm -rf xil_test_receiver


PHONY: xil_project xil_synth xil_impl
xil_project: 
	vivado -mode batch -s tcl/xil_receiver.tcl

xil_synth:
	vivado -mode batch -s tcl/xil_synth.tcl xil_test_receiver/xil_test_receiver.xpr
xil_impl:
	vivado -mode batch -s tcl/xil_impl.tcl xil_test_receiver/xil_test_receiver.xpr

verible.filelist:  rtl/*.v rtl/*.vh
	find . -name "*.sv" -o -name "*.svh" -o -name "*.v" | sort > verible.filelist