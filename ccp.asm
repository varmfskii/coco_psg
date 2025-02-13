ccp_mem0: equ $ff5a
ccp_mem1: equ $ff5b
ccp_crg: equ $ff5d
ccp_reg: equ $ff5e
ccp_dat: equ $ff5f

ccp_pre	macro
	endm
	
ccp_post macro
	endm
	
ccp_init:
	lda #$30
	sta mpi
	lda ccp_crg		; 2MHz mode
	anda #%11111110
	sta ccp_crg
	cart_snd
	ldx #ccp_psg
	lda #13
	clrb
loop@:
	bsr ccp_ctl
	deca
	bpl loop@
	lda #ay_enable
	ldb #%00111000
	bsr ccp_ctl
	rts

ccp_term:	
	lda #8
	ldb #%00111111
	bsr ccp_ctl
	lda #$33
	sta $ff7f
	rts

ccp_ctl:
	pshs y
	ldy scn,x
	sta ccp_reg
	stb ccp_dat
	stb a,y
	puls y,pc
