gmc_snd: equ $ff41
voicea:	equ $80
vola:	equ $90
voiceb:	equ $a0
volb:	equ $b0
voicec:	equ $c0
volc:	equ $d0
noise:	equ $e0
voln:	equ $f0

pia0:	equ $ff00
pia1:	equ $ff20
mpi:	equ $ff7f
	
	org $7000
mute:
	lda #vola|$0f
	sta gmc_snd
	nop
	nop
	lda #volb|$0f
	sta gmc_snd
	nop
	nop
	lda #volc|$0f
	sta gmc_snd
	nop
	nop
	lda #voln|$0f
	sta gmc_snd
	nop
	nop
	rts

cart_snd:
	lda pia0+1
	anda #$f7
	sta pia0+1
	lda pia0+3
	ora #$08
	sta pia0+3
	lda pia1+3
	ora #$08
	sta pia1+3
	rts
	
start:
	lda #' '
	ldx #$0400
cls:
	sta ,x+
	cmpx #$0600
	bne cls
	lda #$30
	sta mpi
	bsr mute
	bsr cart_snd

	lda #vola
	sta gmc_snd
	nop
	nop
repeat@:	
	ldx #tones
loop@:	
	ldd ,x++
	beq exit@
	bsr notea
	bra loop@
exit@:
	ldd tones
	bsr notea
	bsr mute
	lda #$33
	sta mpi
	rts

	;; play note on voice a
notea:
	pshs d
	std $0400+14*32+8
	andb #$0f
	orb #voicea
	stb gmc_snd
	ldd ,s
	lsra
	rorb
	lsra
	rorb
	lsra
	rorb
	lsra
	rorb
	andb #$3f
	stb gmc_snd
	bsr wait
	puls d,pc

	;; play note on voice b
noteb:
	ora #voiceb
	sta gmc_snd
	nop
	nop
	stb gmc_snd
	nop
	nop
	bsr wait
	rts

	;; play note on voice c
notec:
	ora #voicec
	sta gmc_snd
	nop
	nop
	stb gmc_snd
	nop
	nop
	bsr wait
	rts

	;; wait 500 ms
wait:
	pshs d
	lda #30
loop@:
	sta $0400+14*32
	ldb pia0+2		; acknowledge interrupt
	sync
	deca
	bne loop@
	puls d,pc

tones:
	fdb 426,380,338,319,284,253,226
	fdb 213,226,253,284,319,338,380
	fdb 0
	
	end start
