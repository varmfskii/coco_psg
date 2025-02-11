	include "inc/coco.inc"
	include "inc/aypsg.inc"

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
	lbsr ssc_init

;;; init voices
	lda #1
	sta notdone
	ldx #voices
	ldy #scores
loop@:
	ldd ,y++
	std scr,x
	lda #1
	sta cpl,x
	sta dly,x
	leax siz,x
	cmpx #voiceend
	bne loop@
	
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
	bne mainlp
	lbsr ssc_term
	rts

siz:	equ 13
scn:	equ 2
crs:	equ 4
fin:	equ 5
amp:	equ 6
dly:	equ 7
srg:	equ 8
sdt:	equ 9
scr:	equ 10
cpl:	equ 12

interrupt:
	lda pia0+2		; ack interrupt
	;; switch screen color
	lda pia1+2
	eora #$08
	sta pia1+2

	clr notdone
	ldx #voices
loop@:
	dec dly,x
	beq next@		; new note
continue:	
	inc notdone
next_voice:	
	leax siz,x
	cmpx #voiceend
	bne loop@
	lda notdone
	bne skip
	;; tear down interrupt
	lda old
	sta irqvec
	ldd old+1
	std irqvec+1
	lda old+3
	sta pia0+1
	lda old+4
	sta pia0+3
skip:
	;; switch screen color
	lda pia1+2
	eora #$08
	sta pia1+2
	rti
	;; next note
next@:
	ldy scr,x
	lda ,y+
	beq done@		; no more notes
	sta dly,x
	lda amp,x		; set volume
	ldb ,y+
	jsr [,x]
	lda crs,x		; set coarse tone
	ldb ,y+
	jsr [,x]
	lda fin,x		; set fine tone
	ldb ,y+
	jsr [,x]
	sty scr,x
	bra continue
	;; no more notes
done@:
	clrb
	lda crs,x
	jsr [,x]
	lda fin,x
	jsr [,x]
	lda amp,x
	jsr [,x]
	bra next_voice

notdone:
	rmb 1
old:	rmb 5

voices:
voice0:
	fdb ssc_ctl		; routine
	fdb screen+32*2+9
	fcb ay_a_coarse		; tone coarse
	fcb ay_a_fine		; tone fine
	fcb ay_a_amp		; voice amplitude
	rmb 6
voice1:
	fdb ssc_ctl		; routine
	fdb screen+32*2+9
	fcb ay_b_coarse		; tone coarse
	fcb ay_b_fine		; tone fine
	fcb ay_b_amp		; voice amplitude
	rmb 6
voice2:
	fdb ssc_ctl		; routine
	fdb screen+32*2+9
	fcb ay_c_coarse		; tone coarse
	fcb ay_c_fine		; tone fine
	fcb ay_c_amp		; voice amplitude
	rmb 6
voiceend:	

scores:
	fdb score0
	fdb score1
	fdb score2
	
score0:
	fdb $3009,428
	fdb $6000,0
	fdb $3009,428
	fdb $3009,339
	fdb $3009,285
	fdb 0,0
score1:
	fdb $3000,0
	fdb $3009,339
	fdb $3000,0
	fdb $3009,339
	fdb $3009,285
	fdb $3009,226
	fdb 0,0
score2:
	fdb $6000,0
	fdb $6009,285
	fdb $3009,226
	fdb $3009,190
	fdb 0,0

	end start
