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




verible.filelist:  rtl/*.v rtl/*.vh
	find . -name "*.sv" -o -name "*.svh" -o -name "*.v" | sort > verible.filelist