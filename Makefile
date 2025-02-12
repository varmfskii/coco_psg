TGTS=europe.bin sayhello.bin scaleccp.bin scales12.bin scalessc.bin	\
	scalessf.bin scaletst.bin testall.bin testccp.bin		\
	testnull.bin tests12.bin testssc.bin testssf.bin
BASS=demo.bas scales12.bas scalessc.bas scalessf.bas
INCS=inc/coco.inc inc/aypsg.inc

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

testall.bin: testall.asm $(INCS) s12.asm ssc.asm ssf.asm
testccp.bin: testccp.asm $(INCS) ccp.asm
testnull.bin: testnull.asm $(INCS) null.asm
tests12.bin: tests12.asm $(INCS) s12.asm
testssc.bin: testssc.asm $(INCS) ssc.asm
testssf.bin: testssf.asm $(INCS) ssf.asm
scaleccp.bin: scaleccp.asm $(INCS) cocopsg.asm base.asm
scales12.bin: scales12.asm $(INCS) symphony12.asm base.asm
scalessc.bin: scalessc.asm $(INCS) soundspeechcart.asm base.asm
scalessf.bin: scalessf.asm $(INCS) superspritefm.asm base.asm
scaletst.bin: scaletst.asm $(INCS) screen.asm base.asm

.PHONY: all bins clean distclean disk test

clean:
	rm -Rf *~ *# .disk *.txt

distclean: clean
	rm -Rf $(TGTS) PSG.DSK
