PSG:	equ $c0			; psg4
	
a4port:	equ $ff60		; data
b4port:	equ a4port+2		; select
	ifdef PSG
mask:	equ $03 * PSG
	else
mask:	equ $ff
	endif

;;; 
;;; A program to dimulate a europe siren sound
;;;
	org $6000
;;;
;;; Initialisze PIA A & PIA B
;;;
start:
	lda #$00		; data direction mode
	sta a4port+1
	sta b4port+1
	lda #$ff		; all output
	sta a4port
	sta b4port
	lda #$04		; data mode
	sta a4port+1
	sta b4port+1
	lda #$00
	sta a4port
	sta b4port		; select no pia
	clr count
;;;
;;; CoCo initialization
;;;
	lda #$3d
	sta $ff03
	lda #$3f
	sta $ff23
;;;
;;;  Globabl initialization
;;;
	lda #7
	ldb #$fe 		; IO/noise or chan "A" on
	bsr storit
	lda #8
	ldb #$0f		; volume max
	bsr storit
;;;
;;; First tone 440 Hz
;;;
europe:
	lda #0			; reg address
;;; 	ldb #127		; chan A fine
	ldb #128
	bsr storit
	lda #1
	ldb #0			; chan A coarse
	bsr storit
;;;
;;; wait 350 ms
;;;
	bsr wait
;;;
;;; second tone 187 Hz
;;;
	lda #0
;;; 	ldb #43
	ldb #96
	bsr storit
	lda #1
;;; 	ldb #1
	ldb #0
	bsr storit
;;;
;;; wait 350 ms
;;;
	bsr wait
;;;
;;; repeat
;;;
	inc count
	lda count
	cmpa #3
	bne europe		; repeat it
	lda #8
	ldb #0			; silence
	bsr storit
	rts			; return
;;;
;;; This routine assumes the register address
;;; of the AT-89XX is in the accumulator "A" and the
;;; data to be stored is in the accumulator "B".
;;;
;;;         *** PSG 4 ***
;;;
storit:
	sta a4port		; store reg. addr.
	lda #$ff & mask
	sta b4port		; strobe reg. latch
	clr b4port		; strobe inactive
	stb a4port		; store data
	lda #$aa & mask		; strobe data
	sta b4port
	clr b4port		; strobe inactive
	rts
;;;
;;; This routine will waste 350 ms
;;;
wait:
	ldx #$a000
more:
	leax -1,x
	bne more
	rts
;;;
;;;  data area
;;;
count:	rmb 1
;;;
	end start
