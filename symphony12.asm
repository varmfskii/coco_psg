psg1:	equ $03
psg2:	equ $0c
psg3:	equ $30
psg4:	equ $c0
dat:	equ $aa	
reg:	equ $ff
dat_a:	equ $ff60
ctl_a:	equ $ff61
dat_b:	equ $ff62
ctl_b:	equ $ff63
	
pre	macro
	endm

post	macro
	endm

	;; base=CPU freq (0.894665/1.789770)
	;; freq=base/16/tone
tones:	
	fdb 127,113,101,95,85,76,67
	fdb 64,67,76,85,95,101,113
	fdb 0

init:
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
	lda #$3d
	sta $ff03
	lda #$3f
	sta $ff23
	ifdef DEBUG
	ldy #screen
	lda #' '
	tfr a,b
loop@:
	std ,y++
	cmpy #screen+$0200
	bne loop@
	ldy #screen+15*32
	endif
	rts

reset:
	lda #8
	ldb #%00111111
	bsr control
	rts

control:
	ifdef DEBUG
	stb a,y
	endif
	pshs d
	sta dat_a
	lda #reg&psg4
	sta dat_b
	clr dat_b
	stb dat_a
	lda #dat&psg4
	sta dat_b
	clr dat_b
	puls d,pc
