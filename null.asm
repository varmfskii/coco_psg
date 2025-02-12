null_init:
	ldx #nullc
	lda #13
	clrb
loop@:
	bsr null_ctl
	deca
	bpl loop@
	lda #ay_enable
	ldb #%00111000
	bsr null_ctl
	rts

null_term:	
	rts

null_ctl:	
	pshs y
	ldy scn,x
	stb a,y
	puls y,pc
