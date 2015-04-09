VC := iverilog #verilog compiler
VE := vvp #verilog executor
VSRC_DIR := src
VTST_DIR := test

rwildcard=$(wildcard $1$2) $(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2))


SOURCES = $(call rwildcard,$(VSRC_DIR),*.v)
TESTS = $(call rwildcard,$(VTST_DIR),*.v)

VPP := $(TESTS:.v=.vpp)#all compiled tests
VCD := $(TESTS:.v=.vcd)#all executed tests

test: $(VCD)

test/image/ImageProcessorTest.vpp: test/image/ImageProcessorTest.v $(SOURCES) imagea.bmp imageb.bmp
	python binary_image.py imagea.bmp 8
	python binary_image.py imageb.bmp 8
	$(VC) -I $(VSRC_DIR) -I $(VTST_DIR) -o $@ $<

%.vpp: %.v $(SOURCES)
	$(VC) -I $(VSRC_DIR) -I $(VTST_DIR) -o $@ $<

test/image/ImageProcessorTest.vcd: test/image/ImageProcessorTest.vpp 
	$(VE) $^
	python binary_image.py result.txt 64 64

%.vcd: %.vpp
	$(VE) $^

clear: clean
	
clean:
	rm -f $(call rwildcard,$(VTST_DIR),*.vcd) $(call rwildcard,$(VSRC_DIR),*.v.bak) $(call rwildcard,$(VTST_DIR),*.vpp)
