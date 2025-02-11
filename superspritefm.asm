reg:	equ $ff5c
data:	equ $ff5d

pre	macro
	endm

post	macro
	endm
	
tones:	
	fdb 426,380,338,319,284,253,226
	fdb 213,226,253,284,319,338,380
	fdb 0

init:
	lda #$30
	sta mpi
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
	lda #$33
	sta $ff7f
	rts

control:	
	std reg
	ifdef DEBUG
	stb a,y
	endif
	rts
