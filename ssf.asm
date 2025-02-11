ssf_reg: equ $ff5c
ssf_dat: equ $ff5d

ssf_pre	macro
	endm
	
ssf_post macro
	endm
	
ssf_init:
	lda #$30
	sta mpi
	ldx #voice0
	lda #13
	clrb
loop@:
	bsr ssf_ctl
	deca
	bpl loop@
	lda #ay_enable
	ldb #%00111000
	bsr ssf_ctl
	rts

ssf_term:	
	lda #8
	ldb #%00111111
	bsr ssf_ctl
	lda #$33
	sta $ff7f
	rts

ssf_ctl:
	pshs y
	ldy scn,x
	sta ssf_reg
	stb ssf_dat
	stb a,y
	puls y,pc
