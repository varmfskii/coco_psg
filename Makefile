TGTS=europe.bin sayhello.bin scaleccp.bin scales12.bin scalessc.bin	\
	scalessf.bin scaletst.bin testall.bin testccp.bin		\
	testnull.bin tests12.bin testssc.bin testssf.bin scalegmc.bin	\
	testgmc.bin
BASS=scales12.bas scalessc.bas scalessf.bas
PSGINC=inc/coco.inc inc/aypsg.inc
CSGINC=inc/coco.inc inc/sncsg.inc

%.bin: %.asm
	lwasm -b -o$@ -l$(@:bin=txt) $<

.disk/%.bin: %.bin | SNDCARTS.DSK .disk
	decb copy -r -2b $< SNDCARTS.DSK,$(shell ./upper.py $<)
	touch $@

.disk/%.bas: %.bas | SNDCARTS.DSK .disk
	decb copy -r -0b -t $< SNDCARTS.DSK,$(shell ./upper.py $<)
	touch $@

bins: $(TGTS)
all: disk
disk: $(TGTS:%.bin=.disk/%.bin) $(BASS:%.bas=.disk/%.bas) 

SNDCARTS.DSK:
	decb dskini SNDCARTS.DSK

.disk:
	mkdir .disk

scaleccp.bin: scaleccp.asm $(PSGINC) cocopsg.asm base_ay.asm
scales12.bin: scales12.asm $(PSGINC) symphony12.asm base_ay.asm
scalessc.bin: scalessc.asm $(PSGINC) soundspeechcart.asm base_ay.asm
scalessf.bin: scalessf.asm $(PSGINC) superspritefm.asm base_ay.asm
scaletst.bin: scaletst.asm $(PSGINC) screen.asm base_ay.asm
testall.bin: testall.asm $(PSGINC) s12.asm ssc.asm ssf.asm
testccp.bin: testccp.asm $(PSGINC) ccp.asm
testnull.bin: testnull.asm $(PSGINC) null.asm
tests12.bin: tests12.asm $(PSGINC) s12.asm
testssc.bin: testssc.asm $(PSGINC) ssc.asm
testssf.bin: testssf.asm $(PSGINC) ssf.asm
scalegmc.bin: scalegmc.asm $(CSGINC)
testgmc.bin: testgmc.asm $(CSGINC) gmc.asm

.PHONY: all bins clean distclean disk test

clean:
	rm -Rf *~ *# .disk *.txt

distclean: clean
	rm -Rf $(TGTS) SNDCARTS.DSK
