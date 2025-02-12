ctl:	equ $ff5d
reg:	equ $ff5e
data:	equ $ff5f

pre	macro
	endm

post	macro
	endm
	
tones:	
	fdb 284,253,225,213,190,169,150
	fdb 142,150,169,190,213,225,253
	fdb 0

init:
	lda #$30
	sta mpi
	lda ctl			; 2MHz
	anda #%11111110
	sta ctl
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
