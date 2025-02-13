TGTS=europe.bin sayhello.bin scalegmc.bin scaleccp.bin scales12.bin	\
	scalessc.bin scalessf.bin scaletst.bin testall.bin		\
	testccp.bin testnull.bin tests12.bin testssc.bin testssf.bin
BASS=demo.bas scales12.bas scalessc.bas scalessf.bas
PSG=inc/coco.inc inc/aypsg.inc
CSG=inc/coco.inc inc/sncsg.inc

%.bin: %.asm
	lwasm -b -o$@ -l$(@:bin=txt) $<

.disk/%.bin: %.bin | PSG.DSK .disk
	decb copy -r -2b $< PSG.DSK,$(shell ./upper.py $<)
	touch $@

.disk/%.bas: %.bas | PSG.DSK .disk
	decb copy -r -0b -t $< PSG.DSK,$(shell ./upper.py $<)
	touch $@

bins: $(TGTS)
all: disk
disk: $(TGTS:%.bin=.disk/%.bin) $(BASS:%.bas=.disk/%.bas) 

PSG.DSK:
	decb dskini PSG.DSK

.disk:
	mkdir .disk

scaleccp.bin: scaleccp.asm $(PSG) cocopsg.asm base_ay.asm
scalegmc.bin: scalegmc.asm $(CSG)
scales12.bin: scales12.asm $(PSG) symphony12.asm base_ay.asm
scalessc.bin: scalessc.asm $(PSG) soundspeechcart.asm base_ay.asm
scalessf.bin: scalessf.asm $(PSG) superspritefm.asm base_ay.asm
scaletst.bin: scaletst.asm $(PSG) screen.asm base_ay.asm
testall.bin: testall.asm $(PSG) s12.asm ssc.asm ssf.asm
testccp.bin: testccp.asm $(PSG) ccp.asm
testnull.bin: testnull.asm $(PSG) null.asm
tests12.bin: tests12.asm $(PSG) s12.asm
testssc.bin: testssc.asm $(PSG) ssc.asm
testssf.bin: testssf.asm $(PSG) ssf.asm

.PHONY: all bins clean distclean disk test

clean:
	rm -Rf *~ *# .disk *.txt

distclean: clean
	rm -Rf $(TGTS) PSG.DSK
