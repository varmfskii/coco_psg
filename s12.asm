psg1:	equ $03
psg2:	equ $0c
psg3:	equ $30
psg4:	equ $c0
s12_dat: equ $aa	
s12_reg: equ $ff
dat_a:	equ $ff60
ctl_a:	equ $ff61
dat_b:	equ $ff62
ctl_b:	equ $ff63

s12_pre	macro
	clra
	sta ctl_a
	sta ctl_b
	lda #$ff
	sta dat_a
	sta dat_b
	lda #$04
	sta ctl_a
	sta ctl_b
	clra
	sta dat_a
	sta dat_b
	endm
	
s12_post macro
	endm
	
s12_init:
	cart_snd
	s12_pre
	lda #13
	clrb
loop@:
	sta dat_a
	ldb #s12_reg
	stb dat_b
	clr dat_b
	clr dat_a
	ldb #s12_dat
	stb dat_b
	clr dat_b
	deca
	bpl loop@
	lda #ay_enable
	sta dat_a
	ldb #s12_reg
	stb dat_b
	clr dat_b
	lda #%00111000
	sta dat_a
	lda #s12_dat
	sta dat_b
	clr dat_b
	rts

s12_term:	
	rts

s12_ctl:	
	pshs d,y
	ldy scn,x
	stb a,y
	sta dat_a
	lda srg,x
	sta dat_b
	clr dat_b
	stb dat_a
	lda sdt,x
	sta dat_b
	clr dat_b
	puls y,d,pc
