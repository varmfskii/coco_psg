	include "inc/coco.inc"
	include "inc/sncsg.inc"

siz:	equ 13
scn:	equ 2
tne:	equ 4
amp:	equ 6
srg:	equ 7
sdt:	equ 8
dly:	equ 9
scr:	equ 10
cpl:	equ 12

	org $7000
	include "gmc.asm"
start:
	lda #$60
	ldx #screen
cls:
	sta ,x+
	cmpx #screen+$200
	bne cls

;;; initialize ay
	lbsr gmc_init

;;; init voices
	lda #1
	sta not_done
	ldu #voices
loop@:
	ldx ,u++
	beq exit@
	ldd ,u++
	std scr,x
	lda #1
	sta cpl,x
	sta dly,x
	bra loop@
exit@:
	
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
	ldb not_done
	bne mainlp
	lbsr gmc_term
	rts

interrupt:
	lda pia0+2		; ack interrupt
	;; switch screen color
	lda pia1+2
	eora #$08
	sta pia1+2

	clr not_done
	ldu #voices
next_voice:
	ldx ,u
	beq exit@
	leau 4,u
	dec dly,x
	beq next_note		; new note
	inc not_done
	bra next_voice
exit@:
	lda not_done
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
next_note:
	ldy scr,x
	lda ,y+
	sta dly,x
	jsr [,x]
	lda dly,x
	beq next_voice		; no more notes
	sty scr,x
	inc not_done
	bra next_voice

not_done:
	rmb 1
old:	rmb 5

gmc_csg:	equ voice0
	
voices:
	fdb voice0,score0
	fdb voice1,score1
	fdb voice2,score2
	fdb 0
	
voice0:
	fdb gmc_note		; routine
	fdb screen+32*2+9	; screen location
	fdb sn_a_tone		; tone
	fcb sn_a_attn		; voice amplitude
	rmb 6
voice1:
	fdb gmc_note		; routine
	fdb screen+32*2+13	; screen location
	fdb sn_b_tone		; tone
	fcb sn_b_attn		; voice amplitude
	rmb 6
voice2:
	fdb gmc_note		; routine
	fdb screen+32*2+17	; screen location
	fdb sn_c_tone		; tone
	fcb sn_c_attn		; voice amplitude
	rmb 6
voiceend:	

scores:
	fdb score0
	fdb score1
	fdb score2
	
score0:
	fdb $300f,478
	fdb $6000,0
	fdb $300f,478
	fdb $300f,379
	fdb $300f,319
	fdb 0,0
score1:
	fdb $3000,0
	fdb $300f,379
	fdb $3000,0
	fdb $300f,379
	fdb $300f,319
	fdb $300f,253
	fdb 0,0
score2:
	fdb $6000,0
	fdb $600f,319
	fdb $300f,253
	fdb $300f,213
	fdb 0,0

	end start
