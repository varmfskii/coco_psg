pre	macro
	endm

post	macro
	endm
	

tones:	
	fdb 426,380,338,319,284,253,226
	fdb 213,226,253,284,319,338,380
	fdb 0

init:
	ldy #screen
	lda #' '
	tfr a,b
loop@:
	std ,y++
	cmpy #screen+$0200
	bne loop@
	ldy #screen+15*32
	rts
	
reset:
	rts

control:	
	stb a,y
	rts
