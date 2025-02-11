sscrst:	equ $ff7d
sscdat:	equ $ff7e

tones:	
	fdb 254,226,202,190,170,151,135
	fdb 127,135,151,170,190,202,226
	fdb 0

pre	macro
	lbsr busy
	lda #$af
	sta sscdat
	endm
	
post	macro
	lbsr busy
	lda #$ff
	sta sscdat
	endm
	
init:
	ifdef DEBUG
	ldy #screen
	lda #' '
	tfr a,b
loop@:
	std ,y++
	cmpy #screen+$0200
	bne loop@
	ldy #screen+32*15
	endif
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
	bsr reset
	rts

reset:	
	lda #1
	sta sscrst
	clr sscrst
	rts

busy:
	pshs a

loop@:
	lda sscdat
	ifdef DEBUG
	sta screen+14*32+1
	endif
	bpl loop@

	;; wait an extra bit - 46 should actually work
	lda #48
loop@:
	deca
	bne loop@
	
	puls a,pc

control:	
	pshs d
	ifdef DEBUG
	stb a,y
	endif
	bsr busy
	lda ,s
	sta sscdat
	bsr busy
	stb sscdat
	puls d,pc
