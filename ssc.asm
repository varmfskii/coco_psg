ssc_rst	equ $ff7d
ssc_dat	equ $ff7e

ssc_pre	macro
	lbsr ssc_busy
	lda #$af
	sta ssc_dat
	endm
	
ssc_post macro
	lbsr ssc_busy
	lda #$ff
	sta ssc_dat
	endm
	
ssc_init:
	;; sound mux to cart
	lda pia0+1
	anda #%11110111
	sta pia0+1
	lda pia0+3
	ora #%00001000
	sta pia0+3
	;; enable sound
	lda pia1+3
	ora #%00001000
	sta pia1+3
	bsr ssc_reset
	ssc_pre
	ldx #ssc_psg
	lda #13
	clrb
loop@:
	bsr ssc_ctl
	deca
	bpl loop@
	lda #ay_enable
	ldb #%00111000
	bsr ssc_ctl
	rts

ssc_term:	
ssc_reset:	
	lda #1
	sta ssc_rst
	clr ssc_rst
	rts

ssc_busy:
	pshs a

loop@:
	lda ssc_dat
	bpl loop@

	;; wait an extra bit - 46 should actually work
	lda #64
loop@:
	deca
	bne loop@
	
	puls a,pc

ssc_ctl:	
	pshs d,y
	ldy scn,x
	stb a,y
	bsr ssc_busy
	lda ,s
	sta ssc_dat
	bsr ssc_busy
	stb ssc_dat
	puls y,d,pc
