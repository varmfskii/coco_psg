gmc_snd:	equ $ff41
	
gmc_note:
	pshs u
	ldu scn,x
	lda ,y+
	coma
	anda #$0f
	ora amp,x
	sta 2,u
	sta gmc_snd
	lda 1,y
	anda #$0f
	ora tne,x
	sta ,u
	sta gmc_snd
	ldd ,y++
	lsra
	rorb
	lsra
	rorb
	lsra
	rorb
	lsra
	rorb
	andb #$3f
	stb 1,u
	stb gmc_snd
	puls u,pc

gmc_init:
	lda #$9f
	sta gmc_snd
	nop
	nop
	lda #$bf
	sta gmc_snd
	nop
	nop
	lda #$df
	sta gmc_snd
	nop
	nop
	lda #$ff
	sta gmc_snd
	cart_snd
	rts


gmc_term:
	lda #$9f
	sta gmc_snd
	nop
	nop
	lda #$bf
	sta gmc_snd
	nop
	nop
	lda #$df
	sta gmc_snd
	nop
	nop
	lda #$ff
	sta gmc_snd
	rts
	
