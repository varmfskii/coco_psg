	include "inc/coco.inc"
	include "inc/aypsg.inc"

sscctl:	equ control
	
	org $7000
	include "ssc.asm"
start:
	lda #$60
	ldx #screen
cls:
	sta ,x+
	cmpx #screen+$200
	bne cls

;;; initialize ay
	lbsr init
	pre
	lda #ay_enable
	ldb #%00111000
	lbsr control

;;; setup irq routine
	orcc #$50		; disable interrupts
	lda pia0+1
	sta old+3
	anda #$fe
	sta pia0+1
	lda pia0+3
	sta old+4
	ora #$01
	sta pia0+3
	lda irqvec
	sta old
	lda #$7e
	sta irqvec
	ldx irqvec+1
	stx old+1
	ldx #interrupt
	stx irqvec+1
	andcc #$ef		; enable interrupts

;;; main program
	clra
mainlp:	
	inca

	;; top line
	ldx #screen
l@:	
	sta ,x+
	cmpx #screen+32
	bne l@

	;; right size
	ldx #screen+32+31
l@:
	sta ,x
	leax 32,x
	cmpx #screen+$200
	blt l@

	;; bottom line
	ldx #screen+32*15+31
l@:
	sta ,-x
	cmpx #screen+$1e0
	bne l@

	;; left side
	ldx #screen+14*32
l@:
	sta ,x
	leax -32,x
	cmpx #screen
	bne l@

	;; delay
	ldx #2048
l@:
	leax -1,x
	bne l@

	;; check if music is finished
	ldb notdone
	beq mainlp
	rts

siz:	equ 11
scr:	equ 2
crs:	equ 4
fin:	equ 5
amp:	equ 6
cpl:	equ 7
dly:	equ 8
srg:	equ 9
sdt:	equ 10

interrupt:
	lda pia0+2		; ack interrupt
	;; switch screen color
	lda pia1+2
	eora #$08
	sta pia1+2
	
	clr notdone
	ldx voices
playlp:
	jsr [,x]
	leax siz,x
	cmpx #voiceend
	blt playlp
	;; switch screen color
	lda pia1+2
	eora #$08
	sta pia1+2
	lda notdone
	bne skip@
	;; tear down interrupt
	post
	lda old
	sta irqvec
	ldd old+1
	std irqvec+1
	lda old+3
	sta pia0+1
	lda old+4
	sta pia0+3
skip@:
	rti

	rts
scores:
	fdb score0
	fdb score1
	fdb score2
	
voices:
null0:
	fdb playssc		; routine address	(,x)
	fdb score0		; score address 	(2,x)
	fcb ay_a_coarse		; tone coarse		(4,x)
	fcb ay_a_fine		; tone fine		(5,x)
	fcb ay_a_amp		; voice amplitude	(6,x)
	fcb 1			; voice not complete	(7,x)
	fcb 1			; remaining delay	(8,x)
	rmb 2			; unsued
voiceend:	
voice0:	
	fdb playssc		; routine address	(,x)
	fdb score0		; score address 	(2,x)
	fcb ay_a_coarse		; tone coarse		(4,x)
	fcb ay_a_fine		; tone fine		(5,x)
	fcb ay_a_amp		; voice amplitude	(6,x)
	fcb 1			; voice not complete	(7,x)
	fcb 1			; remaining delay	(8,x)
	rmb 2			; unsued
voice1:	
	fdb playssc		; routine address	(,x)
	fdb score1		; score address 	(2,x)
	fcb ay_b_coarse		; tone coarse		(4,x)
	fcb ay_b_fine		; tone fine		(5,x)
	fcb ay_b_amp		; voice amplitude	(6,x)
	fcb 1			; voice not complete	(7,x)
	fcb 1			; remaining delay	(11,x)
	rmb 2			; unsued
voice2:	
	fdb playssc		; routine address	(,x)
	fdb score2		; score address 	(2,x)
	fcb ay_c_coarse		; tone coarse		(4,x)
	fcb ay_c_fine		; tone fine		(5,x)
	fcb ay_c_amp		; voice amplitude	(6,x)
	fcb 1			; voice not complete	(7,x)
	fcb 1			; remaining delay	(11,x)
	rmb 2			; unsued

playssc:	
	lda cpl,x		; voice complete?
	beq exit@
	sta notdone		; song is not notdone 
	dec dly,x		; remaining delay
	bne exit@
	ldy scr,x			; score address
	ldd ,y++
	bne cont@
	inc cpl,x			; set voice complete
exit@:
	rts
cont@:
	sta dly,x		; new delay
	lda amp,x		; amplitude register
	lbsr sscctl
	lda crs,x		; coarse reg
	ldb ,y+
	lbsr sscctl
	lda fin,x		; fine reg
	ldb ,y+
	lbsr sscctl
	sty scr,x		; update score address
	rts

notdone:
	fcb 0
	
score0:
	fdb $ff0f,339
	fdb 0,0
	fcb 1,10,1,83
	fcb 47,15,1,83
	fcb 1,10,1,125
	fcb 47,15,1,125
	fcb 1,10,1,172
	fcb 47,15,1,172
	fcb 1,10,1,125
	fcb 47,15,1,125

	fcb 1,10,1,83
	fcb 47,15,1,83
	fcb 1,10,1,83
	fcb 47,15,1,83
	fcb 1,10,1,83
	fcb 95,15,1,83

	fcb 1,10,1,125
	fcb 47,15,1,125
	fcb 1,10,1,125
	fcb 47,15,1,125
	fcb 1,10,1,125
	fcb 95,15,1,125

	fcb 1,10,1,83
	fcb 47,15,1,83
	fcb 1,10,1,19
	fcb 47,15,1,19
	fcb 1,10,1,19
	fcb 96,15,1,19

	fcb 1,10,1,83
	fcb 47,15,1,83
	fcb 1,10,1,125
	fcb 47,15,1,125
	fcb 1,10,1,172
	fcb 47,15,1,172
	fcb 1,10,1,125
	fcb 47,15,1,125

	fcb 1,10,1,83
	fcb 47,15,1,83
	fcb 1,10,1,83
	fcb 47,15,1,83
	fcb 1,10,1,83
	fcb 47,15,1,83
	fcb 1,10,1,83
	fcb 47,15,1,83

	fcb 1,10,1,125
	fcb 47,15,1,125
	fcb 1,10,1,125
	fcb 47,15,1,125
	fcb 1,10,1,83
	fcb 47,15,1,83
	fcb 1,10,1,125
	fcb 47,15,1,125

	fcb 1,10,1,172
	fcb 191,15,1,172

	fcb 1,10,1,83
	fcb 71,15,1,83
	fcb 1,10,1,125
	fcb 23,15,1,125
	fcb 1,10,1,172
	fcb 47,15,1,172
	fcb 1,10,1,125
	fcb 47,15,1,125

	fcb 1,10,1,83
	fcb 47,15,1,83
	fcb 1,10,1,83
	fcb 47,15,1,83
	fcb 1,10,1,83
	fcb 95,15,1,83

	fcb 1,10,1,125
	fcb 47,15,1,125
	fcb 1,10,1,125
	fcb 47,15,1,125
	fcb 1,10,1,125
	fcb 95,15,1,125

	fcb 1,10,1,83
	fcb 47,15,1,83
	fcb 1,10,1,19
	fcb 47,15,1,19
	fcb 2,10,1,19
	fcb 95,15,1,19

	fcb 1,10,1,83
	fcb 71,15,1,83
	fcb 1,10,1,125
	fcb 23,15,1,125
	fcb 1,10,1,172
	fcb 47,15,1,172
	fcb 1,10,1,125
	fcb 47,15,1,125

	fcb 1,10,1,83
	fcb 47,15,1,83
	fcb 1,10,1,83
	fcb 47,15,1,83
	fcb 1,10,1,83
	fcb 47,15,1,83
	fcb 1,10,1,83
	fcb 47,15,1,83

	fcb 1,10,1,125
	fcb 47,15,1,125
	fcb 1,10,1,125
	fcb 47,15,1,125
	fcb 1,10,1,83
	fcb 47,15,1,83
	fcb 1,10,1,125
	fcb 47,15,1,125

	fcb 1,10,1,172
	fcb 191,15,1,172

	fcb 0,0,0,0
score1:
	fcb 1
	fcb 0,0,0,0
	fcb 192,15,2,166
	
	fcb 192,15,2,166

	fcb 192,15,2,128

	fcb 192,15,2,166

	fcb 192,15,2,166

	fcb 192,15,2,166

	fcb 96,15,2,58
	fcb 96,15,4,116

	fcb 192,15,7,240

	fcb 192,15,2,166

	fcb 192,15,2,166

	fcb 192,15,2,128

	fcb 192,15,2,166

	fcb 192,15,2,166

	fcb 192,15,2,166

	fcb 96,15,2,58
	fcb 96,15,4,116

	fcb 192,15,7,240

	fcb 0,0,0,0
score2:
	fcb 1
	fcb 0,0,0,0
	fcb 192,15,3,88

	fcb 192,15,3,88

	fcb 192,15,3,136

	fcb 192,15,3,88

	fcb 192,15,3,88

	fcb 192,15,3,88

	fcb 192,0,0,0

	fcb 192,0,0,0

	fcb 192,15,3,88

	fcb 192,15,3,88

	fcb 192,15,3,136

	fcb 192,15,3,88

	fcb 192,15,3,88

	fcb 192,15,3,88

	fcb 192,0,0,0

	fcb 192,0,0,0

	fcb 0,0,0,0

old:
	rmb 5
	
	end start
	
