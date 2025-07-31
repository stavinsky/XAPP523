filename = usound
pcf_file = io.pcf

# ICELINK_DIR=$(shell df | grep iCELink | awk '{print $$6}')
# ${warning iCELink path: $(ICELINK_DIR)}
files = manchester_encoder.v manchester_decoder.v manchester_escape.v manchester_preamble.v manchester_serializer.v counter.v 

build:
	yosys -p "synth_ice40 -json $(filename).json -blif $(filename).blif" $(filename).v clock_divider.v rotary_encoder.v debouncer.v clock_divider_fixed.v
	nextpnr-ice40 --lp1k --package cm36 --json $(filename).json --pcf $(pcf_file) --asc $(filename).asc --freq 12 
	icepack $(filename).asc $(filename).bin

flash:
	icesprog -w $(filename).bin


clean:
	rm -rf $(filename).blif $(filename).asc $(filename).bin $(filename).json 
