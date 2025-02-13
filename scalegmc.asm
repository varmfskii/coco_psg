	include "inc/coco.inc"
	include "inc/sncsg.inc"

DEBUG:	equ 1
gmc_snd: equ $ff41
	
	org $7000
mute:
	lda #attna|$0f
	sta gmc_snd
	nop
	nop
	lda #attnb|$0f
	sta gmc_snd
	nop
	nop
	lda #attnc|$0f
	sta gmc_snd
	nop
	nop
	lda #attnn|$0f
	sta gmc_snd
	nop
	nop
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
	cart_snd

	lda #attna|0
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
	ifdef DEBUG
	std $0400+14*32+8
	endif
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

	;; wait 500 ms
wait:
	pshs d
	lda #30
loop@:
	ifdef DEBUG
	sta $0400+14*32
	endif
	ldb pia0+2		; acknowledge interrupt
	sync
	deca
	bne loop@
	puls d,pc

tones:
	fdb 284,253,225,213,190,169,150
	fdb 142,150,169,190,213,225,253
	fdb 0
	
	end start
