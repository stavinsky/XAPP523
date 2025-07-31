IVERILOG=iverilog -I ./rtl -y ./rtl
VVP=vvp

TESTBENCHES = main manchester_serializer manchester_preamble manchester_escape 

tb: clean $(addsuffix .vcd, $(addprefix tb_, $(TESTBENCHES)))

tb_%: rtl/tb_%.v rtl/%.v
	$(IVERILOG) -o $@ $^

%.vcd: %
	$(VVP) $<

.PHONY: clean

clean:
	rm -f tb_* *.vcd
	find . -name "._*" -exec rm {} \;



